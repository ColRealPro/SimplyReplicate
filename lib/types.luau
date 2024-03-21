local Signal = require(script.Parent.Signal)
export type Replicator<T> = {
	changeStates: (self: Replicator<T>, changedStates: T, players: ({ Player } | Player)?) -> (),
	get: (self: Replicator<T>, index: string?) -> T,
	getForPlayer: (self: Replicator<T>, player: Player, index: string?) -> T,
	syncPlayer: (self: Replicator<T>, player: Player) -> (),
	Destroy: (self: Replicator<T>) -> (),

	StateChanged: Signal.Signal<string, any>
}

export type ReplicatorConstructor = {
	new: <T>(identifier: string | Instance, data: T?) -> Replicator<T>,
}

return nil