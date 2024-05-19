"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[405],{3905:(e,t,a)=>{a.d(t,{Zo:()=>s,kt:()=>m});var n=a(67294);function l(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function r(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function i(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?r(Object(a),!0).forEach((function(t){l(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):r(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function o(e,t){if(null==e)return{};var a,n,l=function(e,t){if(null==e)return{};var a,n,l={},r=Object.keys(e);for(n=0;n<r.length;n++)a=r[n],t.indexOf(a)>=0||(l[a]=e[a]);return l}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(n=0;n<r.length;n++)a=r[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(l[a]=e[a])}return l}var p=n.createContext({}),c=function(e){var t=n.useContext(p),a=t;return e&&(a="function"==typeof e?e(t):i(i({},t),e)),a},s=function(e){var t=c(e.components);return n.createElement(p.Provider,{value:t},e.children)},u="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},h=n.forwardRef((function(e,t){var a=e.components,l=e.mdxType,r=e.originalType,p=e.parentName,s=o(e,["components","mdxType","originalType","parentName"]),u=c(a),h=l,m=u["".concat(p,".").concat(h)]||u[h]||d[h]||r;return a?n.createElement(m,i(i({ref:t},s),{},{components:a})):n.createElement(m,i({ref:t},s))}));function m(e,t){var a=arguments,l=t&&t.mdxType;if("string"==typeof e||l){var r=a.length,i=new Array(r);i[0]=h;var o={};for(var p in t)hasOwnProperty.call(t,p)&&(o[p]=t[p]);o.originalType=e,o[u]="string"==typeof e?e:l,i[1]=o;for(var c=2;c<r;c++)i[c]=a[c];return n.createElement.apply(null,i)}return n.createElement.apply(null,a)}h.displayName="MDXCreateElement"},20297:(e,t,a)=>{a.r(t),a.d(t,{assets:()=>p,contentTitle:()=>i,default:()=>d,frontMatter:()=>r,metadata:()=>o,toc:()=>c});var n=a(87462),l=(a(67294),a(3905));const r={},i="Replicating Data",o={unversionedId:"replicatingdata",id:"replicatingdata",title:"Replicating Data",description:"Creating a Replicator",source:"@site/docs/replicatingdata.md",sourceDirName:".",slug:"/replicatingdata",permalink:"/SimplyReplicate/docs/replicatingdata",draft:!1,editUrl:"https://github.com/ColRealPro/SimplyReplicate/edit/main/docs/replicatingdata.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"Getting Started",permalink:"/SimplyReplicate/docs/gettingstarted"}},p={},c=[{value:"Creating a Replicator",id:"creating-a-replicator",level:2},{value:"Listening to Data Changes",id:"listening-to-data-changes",level:2},{value:"Changing States",id:"changing-states",level:2},{value:"Specific Player States",id:"specific-player-states",level:2},{value:"Accessing Data",id:"accessing-data",level:2},{value:"Syncing Players",id:"syncing-players",level:2}],s={toc:c},u="wrapper";function d(e){let{components:t,...a}=e;return(0,l.kt)(u,(0,n.Z)({},s,a,{components:t,mdxType:"MDXLayout"}),(0,l.kt)("h1",{id:"replicating-data"},"Replicating Data"),(0,l.kt)("h2",{id:"creating-a-replicator"},"Creating a Replicator"),(0,l.kt)("p",null,"To create a module, all you will need to do is pass the identifier of the replicator and the states and their default values that will be replicated to the client."),(0,l.kt)("admonition",{title:"Important",type:"important"},(0,l.kt)("p",{parentName:"admonition"},"Whatever states you specify when creating the replicator will be the only states you can change, otherwise an error will be thrown.")),(0,l.kt)("admonition",{type:"tip"},(0,l.kt)("p",{parentName:"admonition"},"When it comes to the identifier of the replicator, you aren't limited to a string! You can use a instance as well, such as a ",(0,l.kt)("inlineCode",{parentName:"p"},"Model")," or a ",(0,l.kt)("inlineCode",{parentName:"p"},"Folder"),"!")),(0,l.kt)("p",null,(0,l.kt)("strong",{parentName:"p"},"Server:")),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local Replicator = require(path.to.module)\n\nlocal ExampleReplicator = Replicator.new("ExampleReplicator", {\n    ExampleState = "ExampleValue",\n    ExampleNumber = 0,\n    ExampleBoolean = false,\n    ExampleTable = {\n        Very = "Cool"\n    }\n})\n')),(0,l.kt)("p",null,(0,l.kt)("strong",{parentName:"p"},"Client:")),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local Replicator = require(path.to.module)\n\nlocal ExampleReplicator = Replicator.new("ExampleReplicator")\n')),(0,l.kt)("h2",{id:"listening-to-data-changes"},"Listening to Data Changes"),(0,l.kt)("p",null,"To listen to data changes on the client, you can use the ",(0,l.kt)("inlineCode",{parentName:"p"},"StateChanged")," signal on the replicator. This signal will fire whenever a state is changed, and will provide the state and new value as arguments."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"ExampleReplicator.StateChanged:Connect(function(state, value)\n    print(state, value)\nend)\n")),(0,l.kt)("p",null,"However, this can get a bit messy if you have multiple states in the same replicator you want to listen to (which you usually do), so here you can use the ",(0,l.kt)("inlineCode",{parentName:"p"},"getStateChangedSignal")," method to get a signal for a specific state."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local ExampleStateSignal = ExampleReplicator:getStateChangedSignal("ExampleState")\nExampleStateSignal:Connect(function(value)\n    print(value)\nend)\n')),(0,l.kt)("p",null,"This will only fire when the ",(0,l.kt)("inlineCode",{parentName:"p"},"ExampleState")," state is changed, and will provide the new value as an argument."),(0,l.kt)("h2",{id:"changing-states"},"Changing States"),(0,l.kt)("p",null,"To change a state in the replicator, you can use the ",(0,l.kt)("inlineCode",{parentName:"p"},"changeStates")," method. This method will take a table of states and their new values, and will replicate them to the client."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'ExampleReplicator:changeStates({\n    ExampleState = "NewValue",\n    ExampleNumber = 5,\n    ExampleBoolean = true,\n    ExampleTable = {\n        Very = "Cooler"\n    }\n})\n')),(0,l.kt)("h2",{id:"specific-player-states"},"Specific Player States"),(0,l.kt)("p",null,"If you ever need to replicate different data to different players, you can do that very easily using the same replicator.\nIn order to do this, you will need to use the ",(0,l.kt)("inlineCode",{parentName:"p"},"changeStates")," method the same way you would normally, but instead, you will specify the players you want to replicate the data to."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'-- Replicating to a specific player\nExampleReplicator:changeStates({\n    ExampleState = "NewValue"\n}, player)\n\n-- Replicating to multiple players\nExampleReplicator:changeStates({\n    ExampleState = "NewValue"\n}, { player1, player2, player3 })\n')),(0,l.kt)("p",null,"To the clients, this will act the exact same as if you were to change the states normally, but only the specified players will receive the new data, and they will still receive state updates that are not player specific as well.\nOn top of this, the server will store a copy of what each player has, so you can access the data for a specific player at any time (See ",(0,l.kt)("a",{parentName:"p",href:"#accessing-data"},"Accessing Data")," for more information)."),(0,l.kt)("admonition",{type:"tip"},(0,l.kt)("p",{parentName:"admonition"},"At some point you may want to resync a player back with the server's data, see ",(0,l.kt)("a",{parentName:"p",href:"#syncing-players"},"Syncing Players")," to learn how to do this.")),(0,l.kt)("h2",{id:"accessing-data"},"Accessing Data"),(0,l.kt)("p",null,"On both the server and the client, you can access the data in the replicator at any time, and it will always be up to date. You can even get the data for a specific player on the server if you need to."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'-- Accessing all the data\nlocal data = ExampleReplicator:get()\nprint(data) -- prints all the data in the replicator\n\n-- Accessing a specific state\nlocal ExampleState = ExampleReplicator:get("ExampleState")\nprint(ExampleState) -- prints the value of ExampleState\n\n-- Accessing a specific player\'s data\nlocal playerData = ExampleReplicator:getForPlayer(player)\nlocal playerExampleState = ExampleReplicator:getForPlayer(player, "ExampleState")\nprint(playerData) -- prints all the data for the player\nprint(playerExampleState) -- prints the value of ExampleState for the player\n')),(0,l.kt)("admonition",{title:"Accessing Player Specific Data",type:"warning"},(0,l.kt)("p",{parentName:"admonition"},"If you attempt to access player specific data on the client, it will throw an error. The client only has access to the data that is replicated to it, and it does not have access to the data for other players.")),(0,l.kt)("h2",{id:"syncing-players"},"Syncing Players"),(0,l.kt)("p",null,"If you have set player specific data for a player, you may want to at some point resync the player with the server's data. This can be done using the ",(0,l.kt)("inlineCode",{parentName:"p"},"syncPlayer")," method."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"ExampleReplicator:syncPlayer(player)\n")),(0,l.kt)("p",null,"Doing this will tell the client to revert all specific changes and replace them with the server's data. This will also fire the ",(0,l.kt)("inlineCode",{parentName:"p"},"StateChanged")," signal for the client as usual."))}d.isMDXComponent=!0}}]);