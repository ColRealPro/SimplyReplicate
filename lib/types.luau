local Signal = require(script.Parent.Signal)
export type Replicator<T> = {
	changeStates: (self: Replicator<T>, changedStates: T, players: ({ Player } | Player)?) -> (),
	get: (self: Replicator<T>, index: string?) -> T,
	getMutable: (self: Replicator<T>, players: ({ Player } | Player)?) -> T,
	getForPlayer: (self: Replicator<T>, player: Player, index: string?) -> T,
	syncPlayer: (self: Replicator<T>, player: Player) -> (),
	getStateChangedSignal: (self: Replicator<T>, state: string) -> Signal.Signal<any>,
	Destroy: (self: Replicator<T>) -> (),

	StateChanged: Signal.Signal<string, any>
}

export type ReplicatorConstructor = {
	new: <T>(identifier: string | Instance, data: T?, useBuffer: boolean?) -> Replicator<T>,
}

return nil