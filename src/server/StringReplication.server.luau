--!nolint LocalUnused
--!strict

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replicator = require(ReplicatedStorage.Shared.SimplyReplicate)

local GameStateReplicator = Replicator.new("GameState", {
	status = "none",
	status2 = "none",
} :: any)

task.wait(5)

GameStateReplicator:changeStates({
	status = "SHARED!!!!",
})

GameStateReplicator.StateChanged:Connect(function(index, value)
	print("State changed", index, value)
end)

for _, v in Players:GetPlayers() do
	GameStateReplicator:changeStates({
		status = "Hello world, this is overriden for " .. v.Name,
		status2 = v.Name,
	}, v)
end

for _, v in Players:GetPlayers() do
	print(`Data for {v.Name}:`, GameStateReplicator:getForPlayer(v))
end

print("Server data:", GameStateReplicator:get())

task.wait(1)

for _,v in Players:GetPlayers() do
	GameStateReplicator:syncPlayer(v)
end

-- for _, v in Players:GetPlayers() do
-- 	print(`Data for {v.Name}:`, GameStateReplicator:getForPlayer(v))
-- end

-- while true do
-- 	GameStateReplicator:changeStates({
-- 		status = HttpService:GenerateGUID(false),
-- 		status2 = HttpService:GenerateGUID(true),
-- 	})

-- 	task.wait(1)
-- end
