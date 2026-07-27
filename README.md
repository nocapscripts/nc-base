**FiveM Roleplay Custom Server built with TypeScript. Currently in testing phase. The future of the project is not yet decided — it may become a fully released server or potentially an open-source project.**


# nc-base — Custom FiveM Framework (TypeScript)

A minimal, but extensible FiveM framework designed for building scalable FiveM servers.

---

# Fixes & Updates

- **Player System**
  - Added commands registry





# Features

- **Player System**
  - Player class wrapper
  - Cash / bank management
  - Job system
  - Gang system
  - Metadata storage
  - Database saving/loading

- **Database System**
  - `oxmysql` integration
  - Async database queries
  - MySQL/MariaDB support

- **Inventory System**
  - `ox_inventory` integration
  - Add/remove items
  - Item checking
  - Stash registration
  - Starter kits

- **Jobs System**
  - Grades
  - Salaries
  - Boss permissions
  - Hiring
  - Firing
  - Promotions
  - Starter items

- **Gang System**
  - Grades
  - Territories
  - Members
  - Boss permissions
  - Starter items

- **Developer Features**
  - TypeScript support
  - `@/` import aliases
  - Webpack build system
  - Lightweight code obfuscation
  - Server/client event system

---

# Requirements

Required:

- FXServer
- Node.js
- npm/yarn
- MySQL/MariaDB

FiveM resources:

- oxmysql
- ox_lib
- ox_inventory


Download:

- https://github.com/overextended/ox_lib
- https://github.com/overextended/ox_inventory


---

# Installation

Install dependencies:

```bash
npm install
```

Build the resource:

```bash
npm run build
```

Output:

```
dist/
 ├── server/server.js
 └── client/client.js
```

Import database:

```bash
mysql -u username -p database < sql/install.sql
```

---

# server.cfg Setup

Resource order matters.

```cfg
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure nc-base
```

Database:

```cfg
set mysql_connection_string "mysql://user:password@localhost/database"
```

---

# Project Structure

```
nc-base

src/
│
├── server/
│   ├── classes/
│   │   └── Player.ts
│   │
│   ├── database/
│   │   └── Database.ts
│   │
│   ├── inventory/
│   │   └── InventoryManager.ts
│   │
│   ├── managers/
│   │   ├── JobManager.ts
│   │   └── GangManager.ts
│   │
│   ├── config/
│   │   ├── jobs.ts
│   │   └── gangs.ts
│   │
│   └── main.ts
│
├── client/
│   └── main.ts
│
└── shared/
    └── types.ts
```

---

# Player System

The Player class handles:

- Player information
- Cash
- Bank
- Job
- Gang
- Metadata
- Identifiers
- Database saving


Example:

```ts
const player = NC.GetPlayer(source)

console.log(player.cash)
console.log(player.job)
console.log(player.gang)
```

---

# Player Metadata

Metadata allows resources to store custom player data.

Example:

```ts
player.setMeta("hunger", 75)
player.setMeta("thirst", 50)
player.setMeta("stress", 10)
```

Get metadata:

```ts
const hunger = player.getMeta("hunger")
```

Example:

```json
{
    "hunger":75,
    "thirst":50,
    "stress":10,
    "dead":false
}
```

---

# Jobs System

Location:

```
src/server/config/jobs.ts
```

Supported:

- Job grades
- Salaries
- Boss access
- Starter items
- Hiring
- Firing
- Promotions


Example:

```ts
police: {
    label: "Police",

    grades: {
        0: {
            name: "Cadet",
            salary: 500
        },

        4: {
            name: "Chief",
            boss: true,
            salary: 2000
        }
    }
}
```

---

# Job Export

Lua:

```lua
local job = exports['nc-base']:GetJob(source)

print(job.name)
print(job.grade)
```

Example return:

```lua
{
    name = "police",
    grade = 4,
    label = "Police"
}
```

---

# Gang System

Location:

```
src/server/config/gangs.ts
```

Features:

- Gang grades
- Territories
- Members
- Boss permissions
- Starter equipment


Example:

```ts
ballas: {

    label: "Ballas",

    territory: "Grove Street",

    grades: {
        0: {
            name:"Member"
        }
    }
}
```

---

# Gang Export

Lua:

```lua
local gang = exports['nc-base']:GetGang(source)

print(gang.name)
```

---

# Inventory System

Powered by:

```
ox_inventory
```

Supported functions:

```
addItem()
removeItem()
giveItems()
removeItems()
canCarryItem()
getItemCount()
registerStash()
```


Example:

```ts
InventoryManager.addItem(
    source,
    "lockpick",
    3
)
```

---

# Starter Kits

Jobs and gangs can automatically give items.


Example:

```ts
items:[
    {
        name:"radio",
        amount:1
    },

    {
        name:"weapon_pistol",
        amount:1
    }
]
```


Items must exist inside:

```
ox_inventory/data/items.lua
```

---

# Stashes

Example stash:

```
police_armory
```

Can be restricted by:

- Job
- Grade
- Permissions


Example:

```ts
InventoryManager.registerStash(
    "police_armory",
    "Police Armory",
    50,
    100000
)
```

---

# Database System

Uses:

```
oxmysql
```


Example:

```ts
const result =
await Database.query(
    "SELECT * FROM players WHERE id=?",
    [id]
)
```

---

# Events

## Server Event

```ts
onNet(
    "nc-base:test",
    (source,data)=>{

        console.log(source)
        console.log(data)

    }
)
```

---

## Server To Client

```ts
emitNet(
    "nc-base:update",
    source,
    data
)
```

---

## Client Event

```ts
onNet(
    "nc-base:update",
    (data)=>{

        console.log(data)

    }
)
```

---

# Exports API

## Get Player

Lua:

```lua
exports['nc-base']:GetPlayer(source)
```


---

## Get Job

```lua
exports['nc-base']:GetJob(source)
```


---

## Get Gang

```lua
exports['nc-base']:GetGang(source)
```


---

## Add Item

```lua
exports['nc-base']:AddItem(
    source,
    "bread",
    5
)
```


---

## Remove Item

```lua
exports['nc-base']:RemoveItem(
    source,
    "bread",
    1
)
```

---

# TypeScript Imports

Instead of:

```ts
../../server/classes/Player
```

Use:

```ts
import { Player } from '@/server/classes/Player';
```


---

# Creating Extensions


## Add Job

Edit:

```
src/server/config/jobs.ts
```


## Add Gang

Edit:

```
src/server/config/gangs.ts
```


## Add Player Data

Update:

```
src/shared/types.ts
```

Update:

- SQL schema
- Player constructor
- Player save function

---

# Resource Example


Lua:

```lua
local player =
exports['nc-base']:GetPlayer(source)


if player then

    print(player.job.name)

end
```


TypeScript:

```ts
const player =
global.exports['nc-base']
.GetPlayer(source)
```

---


Register Commands: 

```ts
import { registerCommand } from '@/server/commands/register';

registerCommand({
    name: '',
    handler: () => {
        
    }
})
```

```lua
exports['nc-base']:regCommand({

    name = "hello",

    permission = "user",

    handler = function(ctx)

        print(
            "Player source:",
            ctx.source
        )

        print(
            "Args:",
            json.encode(ctx.args)
        )

    end
})
```

# Roadmap

Planned:

- Vehicle ownership
- Housing system
- Banking
- Phone system
- MDT
- Character selector
- Admin system
- NUI framework


---

# License

Custom FiveM framework.

Free to modify and extend for your own server.
