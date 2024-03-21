local Replicator = require(script.Replicator)
local types = require(script.types)

return (
	table.freeze({
		new = Replicator.new
	}) :: any
) :: types.ReplicatorConstructor