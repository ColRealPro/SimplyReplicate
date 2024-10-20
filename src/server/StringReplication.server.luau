--!nolint LocalUnused
--!strict

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replicator = require(ReplicatedStorage.Shared.SimplyReplicate)

local GameStateReplicator = Replicator.new(
	"GameState",
	{
		status = "none" :: string?,
		status2 = "none" :: string?,
		testTable = {
			nestedTable = {
				nestedTable2 = {
					Hello = "World",
				}
			}
		},

		InstanceTest = workspace,
	},
	true
)

task.wait(5)
-- if true then return end

-- GameStateReplicator:changeStates({
-- 	status = "SHARED!!!!",
-- })

GameStateReplicator:getMutable().status = "SHARED!!!!"
GameStateReplicator:getMutable().testTable.nestedTable.nestedTable2.Hello = "World2"

GameStateReplicator.StateChanged:Connect(function(index, value)
	print("State changed", index, value)
end)

for _, v in Players:GetPlayers() do
	-- GameStateReplicator:changeStates({
	-- 	status = "Hello world, this is overriden for " .. v.Name,
	-- 	status2 = v.Name,
	-- }, v)

	local mutable = GameStateReplicator:getMutable(v)
	mutable.status = "Hello world, this is overriden for " .. v.Name
	mutable.status2 = v.Name
end

for _, v in Players:GetPlayers() do
	print(`Data for {v.Name}:`, GameStateReplicator:getForPlayer(v))
end

print("Server data:", GameStateReplicator:get())

task.wait(1)

for _, v in Players:GetPlayers() do
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

task.wait(3)
GameStateReplicator:addState("newState", "Hello world")

task.wait(3)

GameStateReplicator:set("newState", "Hello world2")

task.wait(2)
GameStateReplicator:getMutable().InstanceTest = game.ReplicatedStorage
task.wait(2)
GameStateReplicator:getMutable().InstanceTest = workspace
