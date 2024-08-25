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

		local finalizedData = {
			data = manager._useBuffer and msgpack.utf8Encode(msgpack.encode(rawData)) or rawData,
			useBuffer = manager._useBuffer,
		}

		return finalizedData
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
		local tag
		local data

		if self._context == "OnServerEvent" then
			player = table.remove(args, 1)
		end

		tag = table.remove(args, 1)

		data = table.remove(args, 1) :: string

		local decodedData = self._useBuffer and msgpack.decode(msgpack.utf8Decode(data)) or data

		print(`Handling listener for {tag}:`, args)

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

	local fetchedData = self.Fetch:InvokeServer(self._identifier, tag, data)

	self._useBuffer = fetchedData.useBuffer

	local decompressedData = self._useBuffer and msgpack.decode(msgpack.utf8Decode(fetchedData.data))
		or fetchedData.data

	return decompressedData
end

function NetworkManager:send(tag: string, data: any, players: { Player }?)
	local server = RunService:IsServer()

	local compressedData = self._useBuffer and msgpack.utf8Encode(msgpack.encode(data)) or data

	if server and players and #players > 0 then
		for _, sendTo: Player in players do
			print("Sending to player", sendTo)
			self.Remote:FireClient(sendTo, tag, compressedData)
		end
	elseif server then
		print("Sending to all clients")
		self.Remote:FireAllClients(tag, compressedData)
	else
		self.Remote:FireServer(tag, compressedData)
	end
end

function NetworkManager:Destroy()
	self._maid:DoCleaning()
end

return NetworkManager
