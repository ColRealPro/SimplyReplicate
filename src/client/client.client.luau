local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replicator = require(ReplicatedStorage.Shared.SimplyReplicate)
local GameStateReplicator = Replicator.new("GameState")

print(GameStateReplicator)

GameStateReplicator.StateChanged:Connect(function(state, value)
	print("State changed", state, value)
	print(GameStateReplicator:get())
end)

GameStateReplicator:getStateChangedSignal("status"):Connect(function(value)
	print("Status changed", value)
end)

print(GameStateReplicator:get())