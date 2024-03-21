"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[391],{3905:(e,t,a)=>{a.d(t,{Zo:()=>c,kt:()=>g});var n=a(67294);function r(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function o(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function l(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?o(Object(a),!0).forEach((function(t){r(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):o(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function i(e,t){if(null==e)return{};var a,n,r=function(e,t){if(null==e)return{};var a,n,r={},o=Object.keys(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||(r[a]=e[a]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(r[a]=e[a])}return r}var s=n.createContext({}),p=function(e){var t=n.useContext(s),a=t;return e&&(a="function"==typeof e?e(t):l(l({},t),e)),a},c=function(e){var t=p(e.components);return n.createElement(s.Provider,{value:t},e.children)},u="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var a=e.components,r=e.mdxType,o=e.originalType,s=e.parentName,c=i(e,["components","mdxType","originalType","parentName"]),u=p(a),m=r,g=u["".concat(s,".").concat(m)]||u[m]||d[m]||o;return a?n.createElement(g,l(l({ref:t},c),{},{components:a})):n.createElement(g,l({ref:t},c))}));function g(e,t){var a=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=a.length,l=new Array(o);l[0]=m;var i={};for(var s in t)hasOwnProperty.call(t,s)&&(i[s]=t[s]);i.originalType=e,i[u]="string"==typeof e?e:r,l[1]=i;for(var p=2;p<o;p++)l[p]=a[p];return n.createElement.apply(null,l)}return n.createElement.apply(null,a)}m.displayName="MDXCreateElement"},85787:(e,t,a)=>{a.r(t),a.d(t,{assets:()=>s,contentTitle:()=>l,default:()=>d,frontMatter:()=>o,metadata:()=>i,toc:()=>p});var n=a(87462),r=(a(67294),a(3905));const o={},l="Getting Started",i={unversionedId:"gettingstarted",id:"gettingstarted",title:"Getting Started",description:"Install",source:"@site/docs/gettingstarted.md",sourceDirName:".",slug:"/gettingstarted",permalink:"/SimplyReplicate/docs/gettingstarted",draft:!1,editUrl:"https://github.com/ColRealPro/SimplyReplicate/edit/master/docs/gettingstarted.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"About",permalink:"/SimplyReplicate/docs/intro"},next:{title:"Replicating Data",permalink:"/SimplyReplicate/docs/replicatingdata"}},s={},p=[{value:"Install",id:"install",level:2},{value:"Basic Usage",id:"basic-usage",level:2}],c={toc:p},u="wrapper";function d(e){let{components:t,...a}=e;return(0,r.kt)(u,(0,n.Z)({},c,a,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"getting-started"},"Getting Started"),(0,r.kt)("h2",{id:"install"},"Install"),(0,r.kt)("p",null,"boo!! not done yet"),(0,r.kt)("h2",{id:"basic-usage"},"Basic Usage"),(0,r.kt)("p",null,"For this example I will demonstrate creating a very simple status replication system"),(0,r.kt)("p",null,"On both the client and the server you are going to want to create a replicator with the same key, and specify the default states and their default values"),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Server:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local Replicator = require(path.to.module)\n\nlocal GameStateReplicator = Replicator.new("GameState", {\n    Status = "Waiting for players",\n    RoundStarted = false\n})\n')),(0,r.kt)("admonition",{type:"important"},(0,r.kt)("p",{parentName:"admonition"},"Whatever states you specify when creating the replicator will be the only states you can change, otherwise an error will be thrown")),(0,r.kt)("admonition",{type:"note"},(0,r.kt)("p",{parentName:"admonition"},"If you are using strict Luau, you will want to add a type cast to the second argument to make everything optional, this way when you go to use the ",(0,r.kt)("inlineCode",{parentName:"p"},"changeStates")," method, you won't have to worry about TypeErrors for missing states")),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Client:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local Replicator = require(path.to.module)\n\nlocal GameStateReplicator = Replicator.new("GameState")\n')),(0,r.kt)("p",null,"Great! We now have a replicator on both the client and the server, now we can start changing the states and they will be replicated to the client!"),(0,r.kt)("p",null,"To change a state in the replicator we will use the ",(0,r.kt)("inlineCode",{parentName:"p"},"changeStates")," method as seen below"),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Server:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'GameStateReplicator:changeStates({\n    Status = "Game starting in 5 seconds"\n})\n')),(0,r.kt)("admonition",{type:"note"},(0,r.kt)("p",{parentName:"admonition"},"You do not need to specify all the states when changing them, only the ones you want to change")),(0,r.kt)("p",null,"Now that we have the server able to change the states, we need to listen for the changes on the client, to do this we will use the ",(0,r.kt)("inlineCode",{parentName:"p"},"StateChanged")," signal as seen below"),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Client:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"GameStateReplicator.StateChanged:Connect(function(state, value)\n    print(state, value) -- Status, Game starting in 5 seconds\nend)\n")),(0,r.kt)("p",null,"Hooraay! You have now successfully created a simple status replication system using SimplyReplicate! This is just the tip of the iceberg, there are many more features and use cases for SimplyReplicate, so be sure to check out ",(0,r.kt)("a",{parentName:"p",href:"/SimplyReplicate/docs/replicatingdata"},"Replicating Data")," or the ",(0,r.kt)("a",{parentName:"p",href:"/api/Replicator"},"API Reference")," for more information."))}d.isMDXComponent=!0}}]);