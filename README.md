# SimplyReplicate

SimplyReplicate is a powerful, user-friendly module designed for seamless data replication between server and clients in Roblox. It is designed to be easy to use, being strictly typed in [Luau](https://luau-lang.org/), and built to be efficient with network usage as well.

## Usage
For this example I will demonstrate creating a very simple status replication system

On both the client and the server you are going to want to create a replicator with the same key, and specify the default states and their default values

**Server:**
```lua
local Replicator = require(path.to.module)

local GameStateReplicator = Replicator.new("GameState", {
	Status = "Waiting for players",
	RoundStarted = false
})
```
> [!IMPORTANT]
Whatever states you specify when creating the replicator will be the only states you can change, otherwise an error will be thrown

> [!NOTE]
If you are using strict Luau, you will want to add a type to the second argument to make everything optional, this way when you go to use the `changeStates` method, you won't have to worry about TypeErrors for missing states

**Client:**
```lua
local Replicator = require(path.to.module)

local GameStateReplicator = Replicator.new("GameState")
```

Great! We now have a replicator on both the client and the server, now we can start changing the states and they will be replicated to the client!

To change a state in the replicator we will use the `changeStates` method as seen below

**Server:**
```lua
GameStateReplicator:changeStates({
	Status = "Game starting in 5 seconds"
})
```

> [!NOTE]
You do not need to specify all the states when changing them, only the ones you want to change

Now that we have the server able to change the states, we need to listen for the changes on the client, to do this we will use the `StateChanged` signal as seen below

**Client:**
```lua
GameStateReplicator.StateChanged:Connect(function(state, value)
	print(state, value) -- Status, Game starting in 5 seconds
end)
```

Hooray! We now have a basic understanding of how to create a replicator! There is more to it than just this, but this is the basics of how to use it, more information can be found in the [documentation](https://ColRealPro.github.io/SimplyReplicate/)
