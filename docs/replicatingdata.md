# Replicating Data

## Creating a Replicator

To create a module, all you will need to do is pass the identifier of the replicator and the states and their default values that will be replicated to the client.

:::important Important
Whatever states you specify when creating the replicator will be the only states you can change, otherwise an error will be thrown.
:::

:::tip
When it comes to the identifier of the replicator, you aren't limited to a string! You can use a instance as well, such as a `Model` or a `Folder`!
:::

**Server:**
```lua
local Replicator = require(path.to.module)

local ExampleReplicator = Replicator.new("ExampleReplicator", {
	ExampleState = "ExampleValue",
	ExampleNumber = 0,
	ExampleBoolean = false,
	ExampleTable = {
		Very = "Cool"
	}
})
```

:::tip Avoiding type errors
When defining the default values, you should add an optional type cast so luau doesnt force you to include every state when using changeStates.

```lua
local ExampleReplicator = Replicator.new("ExampleReplicator", {
	ExampleState = "ExampleValue" :: string?,
	ExampleNumber = 0 :: number?,
	ExampleBoolean = false :: boolean?,
	ExampleTable = {
		Very = "Cool"
	} :: {string: string}?,
})
```
:::

:::tip Replicating nil
If you want to replicate a state as `nil` you must use `Replicator.null` to do so, otherwise your state will not be replicated or registered.
:::

**Client:**
```lua
local Replicator = require(path.to.module)

local ExampleReplicator = Replicator.new("ExampleReplicator")
```

## Listening to Data Changes

To listen to data changes on the client, you can use the `StateChanged` signal on the replicator. This signal will fire whenever a state is changed, and will provide the state and new value as arguments.

```lua
ExampleReplicator.StateChanged:Connect(function(state, value)
	print(state, value)
end)
```

However, this can get a bit messy if you have multiple states in the same replicator you want to listen to (which you usually do), so here you can use the `getStateChangedSignal` method to get a signal for a specific state.

```lua
local ExampleStateSignal = ExampleReplicator:getStateChangedSignal("ExampleState")
ExampleStateSignal:Connect(function(value)
	print(value)
end)
```

This will only fire when the `ExampleState` state is changed, and will provide the new value as an argument.

## Changing States

<!-- To change a state in the replicator, you can use the `changeStates` method. This method will take a table of states and their new values, and will replicate them to the client. -->

To change a state in the replicator, there are multiple ways you can do this. The first way is to use the `changeStates` method. This method will take a table of states and their new values, and will replicate them to the client.

```lua
ExampleReplicator:changeStates({
	ExampleState = "NewValue",
	ExampleNumber = 5,
	ExampleBoolean = true,
	ExampleTable = {
		Very = "Cooler"
	}
})
```

:::tip Replicating nil
If you want to replicate a state as `nil` you must use `Replicator.null` to do so, otherwise your state will not be replicated.
This only applies to the `changeStates` method and when creating the replicator.
:::

The second way is to use the `set` method to change a single state. This method will take the state and the new value as arguments, and will replicate it to the client.

```lua
ExampleReplicator:set("ExampleState", "NewValue")
```

The third way is to use the `getMutable` method to get a mutable version of the replicator data, and when you edit the data in this version, your changes will be automatically repliated to the client.

```lua
local data = ExampleReplicator:getMutable()
data.ExampleState = "NewValue"
```

## Adding new states

If you want to add a new state to the replicator after it has been created, you can use the `addState` method. This will avoid the errors that would be thrown if you tried to change a state that wasn't specified when creating the replicator, and allow you to use the new state like any other.

```lua
ExampleReplicator:addState("NewState", "NewValue")
```

## Specific Player States

If you ever need to replicate different data to different players, you can do that very easily using the same replicator.
In order to do this, you will need to use the `changeStates` or `set` method the same way you would normally, but instead, you will specify the players you want to replicate the data to.

```lua
-- Replicating to a specific player
ExampleReplicator:changeStates({
	ExampleState = "NewValue"
}, player)
ExampleReplicator:set("ExampleState", "NewValue", player)

-- Replicating to multiple players
ExampleReplicator:changeStates({
	ExampleState = "NewValue"
}, { player1, player2, player3 })
ExampleReplicator:set("ExampleState", "NewValue", { player1, player2, player3 })
```

:::tip
If you are using `getMutable` to change data, you can supply the players you want to replicate the data to as the first argument.

```lua
local data = ExampleReplicator:getMutable(player)
data.ExampleState = "NewValue" -- Only player will receive this change

local data = ExampleReplicator:getMutable({ player1, player2, player3 })
data.ExampleState = "NewValue" -- Only player1, player2, and player3 will receive this change
```
:::

To the clients, this will act the exact same as if you were to change the states normally, but only the specified players will receive the new data, and they will still receive state updates that are not player specific as well.
On top of this, the server will store a copy of what each player has, so you can access the data for a specific player at any time (See [Accessing Data](#accessing-data) for more information).

:::tip
At some point you may want to resync a player back with the server's data, see [Syncing Players](#syncing-players) to learn how to do this.
:::

## Accessing Data

On both the server and the client, you can access the data in the replicator at any time, and it will always be up to date. You can even get the data for a specific player on the server if you need to.

```lua
-- Accessing all the data
local data = ExampleReplicator:get()
print(data) -- prints all the data in the replicator

-- Accessing a specific state
local ExampleState = ExampleReplicator:get("ExampleState")
print(ExampleState) -- prints the value of ExampleState

-- Accessing a specific player's data
local playerData = ExampleReplicator:getForPlayer(player)
local playerExampleState = ExampleReplicator:getForPlayer(player, "ExampleState")
print(playerData) -- prints all the data for the player
print(playerExampleState) -- prints the value of ExampleState for the player
```

:::warning Accessing Player Specific Data
If you attempt to access player specific data on the client, it will throw an error. The client only has access to the data that is replicated to it, and it does not have access to the data for other players.
:::

## Syncing Players

If you have set player specific data for a player, you may want to at some point resync the player with the server's data. This can be done using the `syncPlayer` method.

```lua
ExampleReplicator:syncPlayer(player)
```

Doing this will tell the client to revert all specific changes and replace them with the server's data. This will also fire the `StateChanged` signal for the client as usual.