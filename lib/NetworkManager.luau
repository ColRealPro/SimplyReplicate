--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Instanciate = require(script.Parent.Instanciate)
local Maid = require(script.Parent.Maid)
local console = require(script.Parent.console)
local msgpack = require(script.Parent.msgpack)

local NetworkManager: NetworkManagerImpl = {} :: NetworkManagerImpl
NetworkManager.__index = NetworkManager
NetworkManager._initialized = false

local ActiveNetworkManagers = {}

-- console.WriteEnv()
local print = console.log

-- // Internal Types
type NetworkManagerImpl = {
	__index: NetworkManagerImpl,
	_initialized: boolean,
	_useBuffer: boolean,

	new: (identifier: string | Instance, useBuffer: boolean?) -> NetworkManager,
	_init: () -> (),
	listen: (self: NetworkManager, tag: string, callback: (...any?) -> nil) -> (),
	listenToFetch: (self: NetworkManager, tag: string, callback: (player: Player, ...any?) -> any?) -> (),
	_handleFetch: (self: NetworkManager, tag: string, data: any?) -> any?,
	fetch: (self: NetworkManager, tag: string, data: any?) -> any?,
	fixData: (self: NetworkManager, data: any) -> (any, { any }),
	parseFixedData: (self: NetworkManager, data: any, extraArgs: { any }) -> any,
	send: (self: NetworkManager, tag: string, data: any, player: { Player }?) -> (),
	Destroy: (self: NetworkManager) -> (),

	RemoteFolder: Folder,
	Remote: RemoteEvent,
	Fetch: RemoteFunction,
}

export type NetworkManager = typeof(setmetatable(
	{} :: {
		_identifier: string | Instance,
		_useBuffer: boolean?,
		_maid: typeof(Maid),
		_fetchListeners: { [string]: (...any) -> any? },
		_context: string,
		_initialized: boolean,
	},
	{} :: NetworkManagerImpl
))

function NetworkManager._init()
	local self = NetworkManager

	if self._initialized then
		return
	end

	if RunService:IsClient() then
		self.RemoteFolder = ReplicatedStorage:WaitForChild("__REPLICATOR_INTERNAL")
		self.Remote = self.RemoteFolder:WaitForChild("ReplicatorNetwork") :: RemoteEvent
		self.Fetch = self.RemoteFolder:WaitForChild("ReplicatorFetch") :: RemoteFunction
		self._initialized = true

		print("Initialized network manager on client")

		return
	end

	self.RemoteFolder = Instanciate("Folder", {
		Name = "__REPLICATOR_INTERNAL",
		Parent = ReplicatedStorage,
	})

	self.Remote = Instanciate("RemoteEvent", {
		Name = "ReplicatorNetwork",
		Parent = self.RemoteFolder,
	})

	self.Fetch = Instanciate("RemoteFunction", {
		Name = "ReplicatorFetch",
		Parent = self.RemoteFolder,
	})

	self.Fetch.OnServerInvoke = function(player, identifier, tag, data)
		local manager = ActiveNetworkManagers[identifier]

		if not manager then
			error("No network manager found for identifier: " .. identifier, 1)
		end

		local rawData = manager:_handleFetch(tag, data)
		local fixedData, extraArgs = manager:fixData(rawData)

		local finalizedData = {
			data = manager._useBuffer and msgpack.utf8Encode(msgpack.encode(fixedData)) or rawData,
			useBuffer = manager._useBuffer,
		}

		return extraArgs, finalizedData
	end

	self._initialized = true
	print("Initialized network manager on server")
end

function NetworkManager.new(identifier: string | Instance, useBuffer: boolean?): NetworkManager
	local self = setmetatable({}, NetworkManager)

	self._identifier = identifier
	self._useBuffer = useBuffer or false
	self._maid = Maid.new()
	self._fetchListeners = {}
	self._context = RunService:IsServer() and "OnServerEvent" or "OnClientEvent"
	self._initialized = self._initialized

	self._init()

	ActiveNetworkManagers[identifier] = self

	return self
end

function NetworkManager:listen(tag: string, callback: (...any?) -> nil)
	local events = {
		OnServerEvent = self.Remote.OnServerEvent,
		OnClientEvent = self.Remote.OnClientEvent,
	}

	self._maid:GiveTask(events[self._context]:Connect(function(...)
		local args = { ... }
		local player
		local identifier
		local tag
		local data
		local extraArgs

		if self._context == "OnServerEvent" then
			player = table.remove(args, 1)
		end

		tag = table.remove(args, 1)
		identifier = table.remove(args, 1)

		extraArgs = table.remove(args, 1) :: { any }
		data = table.remove(args, 1) :: string

		if identifier ~= self._identifier then
			-- print("Identifier mismatch", identifier, self._identifier)
			return
		end

		-- print("ExtraArgs", extraArgs)
		-- print("Data", data)
		-- print("UseBuffer", self._useBuffer)

		local decodedData = self._useBuffer and msgpack.decode(msgpack.utf8Decode(data)) or data

		if extraArgs and typeof(decodedData) == "table" then
			decodedData = self:parseFixedData(decodedData, extraArgs)
		end

		print(`Handling listener for {tag}:`, decodedData)

		if self._context == "OnServerEvent" then
			callback(player, decodedData)
		else
			callback(decodedData)
		end
	end))
end

function NetworkManager:listenToFetch(tag: string, callback: (player: Player, ...any?) -> any?)
	self._fetchListeners[tag] = callback
end

function NetworkManager:_handleFetch(tag: string, data: any?)
	local listener = self._fetchListeners[tag]

	if not listener then
		error("No listener found for fetch tag: " .. tag, 1)
	end

	return listener(data)
end

function NetworkManager:fetch(tag: string, data: any?)
	if self._context == "OnServerEvent" then
		error("Cannot fetch on server", 2)
	end

	local extraArgs, fetchedData = self.Fetch:InvokeServer(self._identifier, tag, data)

	self._useBuffer = fetchedData.useBuffer

	local decompressedData = self._useBuffer and msgpack.decode(msgpack.utf8Decode(fetchedData.data))
		or fetchedData.data

	if extraArgs then
		-- print("PARSING FIXED DATA", decompressedData)
		decompressedData = self:parseFixedData(decompressedData, extraArgs)
	end

	return decompressedData
end

function NetworkManager:fixData(data: any)
	local AllowedTypes = {
		"string",
		"number",
		"boolean",
		"table",
	}

	local ExtraArgs = {}

	local function iterateTbl(tbl)
		for i, v in tbl do
			if typeof(v) == "table" then
				if v.__THISISANEXTRAARG__ and v.__EXTRAARGINDEX__ then
					error("You are trying to replicate a table that is using keys that are reserved for the network manager. These keys are: __THISISANEXTRAARG__, __EXTRAARGINDEX__", 3)
				end

				iterateTbl(v)
			elseif not table.find(AllowedTypes, typeof(v)) then
				table.insert(ExtraArgs, v)

				tbl[i] = {
					__THISISANEXTRAARG__ = true,
					__EXTRAARGINDEX__ = #ExtraArgs,
				}
			end
		end
	end

	if self._useBuffer then iterateTbl(data) end

	return data, ExtraArgs
end

function NetworkManager:parseFixedData(data: any, extraArgs: { any })
	local function iterateTbl(tbl)
		for i, v in tbl do
			if typeof(v) == "table" and v.__THISISANEXTRAARG__ and v.__EXTRAARGINDEX__ then
				tbl[i] = extraArgs[v.__EXTRAARGINDEX__]
			elseif typeof(v) == "table" then
				iterateTbl(v)
			end
		end
	end

	iterateTbl(data)

	return data
end

function NetworkManager:send(tag: string, data: any, players: { Player }?)
	local server = RunService:IsServer()

	local FixedData, ExtraArgs = self:fixData(data)
	local compressedData = self._useBuffer and msgpack.utf8Encode(msgpack.encode(FixedData)) or data

	print("ExtraArgs", ExtraArgs)

	if server and players and #players > 0 then
		for _, sendTo: Player in players do
			print("Sending to player", sendTo)
			self.Remote:FireClient(sendTo, tag, self._identifier, ExtraArgs, compressedData)
		end
	elseif server then
		print("Sending to all clients")
		self.Remote:FireAllClients(tag, self._identifier, ExtraArgs, compressedData)
	else
		self.Remote:FireServer(tag, self._identifier, ExtraArgs, compressedData)
	end
end

function NetworkManager:Destroy()
	self._maid:DoCleaning()
end

return NetworkManager
