local Signal = require(script.Parent.Signal)

export type null = any
export type Replicator<T> = {
	changeStates: (self: Replicator<T>, changedStates: T, players: ({ Player } | Player)?) -> (),
	get: (self: Replicator<T>, index: string?) -> T,
	set: (self: Replicator<T>, state: string, value: any, players: ({ Player } | Player)?) -> (),
	getMutable: (self: Replicator<T>, players: ({ Player } | Player)?) -> T,
	getForPlayer: (self: Replicator<T>, player: Player, index: string?) -> T,
	syncPlayer: (self: Replicator<T>, player: Player) -> (),
	getStateChangedSignal: (self: Replicator<T>, state: string) -> Signal.Signal<any>,
	Destroy: (self: Replicator<T>) -> (),

	StateChanged: Signal.Signal<string, any>,
}

export type ReplicatorConstructor = {
	new: <T>(identifier: string | Instance, data: T?, useBuffer: boolean?) -> Replicator<T>,
	null: null,
}

return nil