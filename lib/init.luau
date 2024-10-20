local Replicator = require(script.Replicator)
local types = require(script.types)

export type null = types.null

return (
	table.freeze({
		new = Replicator.new,
		null = Replicator.null,
	}) :: any
) :: types.ReplicatorConstructor