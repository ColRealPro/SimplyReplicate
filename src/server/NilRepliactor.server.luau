local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replicator = require(ReplicatedStorage.Shared.SimplyReplicate)

local NilReplicator = Replicator.new(
	"NilTest",
	{
		status = "none" :: string?,
		status2 = Replicator.null :: Replicator.null?,
	}
)

task.wait(5)

NilReplicator.StateChanged:Connect(function(index, value)
	print("State changed", index, value)
end)

print("SETTING TO NIL")
NilReplicator:getMutable().status = nil

task.wait(2)
NilReplicator:getMutable().status = "OO recovered from nil!"
NilReplicator:getMutable().status2 = "OO recovered from nil 2!"