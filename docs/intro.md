---
sidebar_position: 1
---

# About

SimplyReplicate is a powerful, user-friendly module designed for seamless data replication between server and clients in Roblox. It is designed to be easy to use, being strictly typed in [Luau](https://luau-lang.org/), and built to be efficient with network usage as well.

See the [Getting Started](gettingstarted.md) guide to get started with SimplyReplicate.

## Features

- **Strictly Typed**: SimplyReplicate is strictly typed in [Luau](https://luau-lang.org/), meaning everything is correctly typed and you won't have to worry about runtime errors because you put a value in the wrong place.
- **Player Specific Replication**: If you ever need to replicate different data to different players, you can 100% do that with SimplyReplicate with the same replicator. SimplyReplicate will handle all the replication for you.
- **Always in Sync**: SimplyReplicate will ensure that all clients are properly receiving the exact data that the server has, and you worry about out of sync data.
- **Accessing Data**: On both the server and the client, you can access the data in the replicator at any time, and it will always be up to date. You can even get the data for a specific player on the server if you need to.
- **Signal Based**: SimplyReplicate uses signals to notify you when the data has changed, so you can easily listen for changes and handle them accordingly.
- **Efficient**: SimplyReplicate is built to be efficient with network usage, meaning if you only modify one state, only that state will be replicated to the clients.
- **Easy to Use**: SimplyReplicate is designed to be easy to use, with a simple API and easy to understand documentation.