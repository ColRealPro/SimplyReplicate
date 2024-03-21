--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Instanciate = require(script.Parent.Instanciate)
local Maid = require(script.Parent.Maid)
local console = require(script.Parent.console)

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

	new: (identifier: string | Instance) -> NetworkManager,
	_init: (self: NetworkManager) -> (),
	listen: (self: NetworkManager, tag: string, callback: (...any?) -> nil) -> (),
	listenToFetch: (self: NetworkManager, tag: string, callback: (player: Player, ...any?) -> any?) -> (),
	_handleFetch: (self: NetworkManager, tag: string, data: any?) -> any?,
	fetch: (self: NetworkManager, tag: string, data: any?) -> any?,
	send: (self: NetworkManager, tag: string, data: any, player: { Player }?) -> (),
	Destroy: (self: NetworkManager) -> (),
}

export type NetworkManager = typeof(setmetatable({} :: {
	_identifier: string | Instance,
	_maid: typeof(Maid),
	_fetchListeners: { [string]: (...any) -> any? },
	_context: string,
	_initialized: boolean,
	RemoteFolder: Folder,
	Remote: RemoteEvent,
	Fetch: RemoteFunction,
}, {} :: NetworkManagerImpl))

function NetworkManager:_init()
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

		return manager:_handleFetch(tag, data)
	end

	self._initialized = true
	print("Initialized network manager on server")
end

function NetworkManager.new(identifier: string | Instance): NetworkManager
	local self = setmetatable({}, NetworkManager)

	
	self._identifier = identifier
	self._maid = Maid.new()
	self._fetchListeners = {}
	self._context = RunService:IsServer() and "OnServerEvent" or "OnClientEvent"
	self._initialized = self._initialized
	self.RemoteFolder = self.RemoteFolder
	self.Remote = self.Remote
	self.Fetch = self.Fetch
	
	self:_init()

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

		if self._context == "OnServerEvent" then
			player = table.remove(args, 1)
		end

		tag = table.remove(args, 1)

		print(`Handling listener for {tag}:`, args)

		if self._context == "OnServerEvent" then
			callback(player, unpack(args))
		else
			callback(unpack(args))
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

	return self.Fetch:InvokeServer(self._identifier, tag, data)
end

function NetworkManager:send(tag: string, data: any, players: { Player }?)
	local server = RunService:IsServer()

	if server and players and #players > 0 then
		for _, sendTo: Player in players do
			print("Sending to player", sendTo)
			self.Remote:FireClient(sendTo, tag, data)
		end
	elseif server then
		print("Sending to all clients")
		self.Remote:FireAllClients(tag, data)
	else
		self.Remote:FireServer(tag, data)
	end
end

function NetworkManager:Destroy()
	self._maid:DoCleaning()
end

return NetworkManager
