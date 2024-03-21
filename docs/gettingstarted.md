# Getting Started

## Install

Installing SimplyReplicate is very simple. You can either download the module from the [Releases Page](https://github.com/ColRealPro/SimplyReplicate/releases) or install it using Wally.

**Roblox Studio:**
- Get the rbxm file from the [Releases Page](https://github.com/ColRealPro/SimplyReplicate/releases) and insert it into your game

**Wally:**
- Add SimplyReplicate to your `wally.toml` dependency list (e.g. `SimplyReplicate = "colrealpro/simplyreplicate@^0.1.2"`)
- Run `wally install` in your terminal

:::note Wally
Not familiar with Wally? Wally is a package manager (like NPM) for the Roblox ecosystem.
To get started, check out the [Wally repository](https://github.com/UpliftGames/wally).
:::

## Basic Usage

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

:::important
Whatever states you specify when creating the replicator will be the only states you can change, otherwise an error will be thrown
:::

:::note
If you are using strict Luau, you will want to add a type cast to the second argument to make everything optional, this way when you go to use the `changeStates` method, you won't have to worry about TypeErrors for missing states
:::

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

:::note
You do not need to specify all the states when changing them, only the ones you want to change
:::

Now that we have the server able to change the states, we need to listen for the changes on the client, to do this we will use the `StateChanged` signal as seen below

**Client:**
```lua
GameStateReplicator.StateChanged:Connect(function(state, value)
	print(state, value) -- Status, Game starting in 5 seconds
end)
```

Hooraay! You have now successfully created a simple status replication system using SimplyReplicate! This is just the tip of the iceberg, there are many more features and use cases for SimplyReplicate, so be sure to check out [Replicating Data](replicatingdata.md) or the [API Reference](/api/Replicator) for more information.