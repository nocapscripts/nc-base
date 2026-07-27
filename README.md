# nc-base — custom FiveM framework (TypeScript)

A minimal, but extensible FiveM framework that includes:

- **Player class** (`src/server/classes/Player.ts`) — wraps player state (cash, job, gang, metadata)
- **Database** (`src/server/database/Database.ts`) — uses `oxmysql` resource exports (must be running as a separate resource on the server)
- **Inventory** (`src/server/inventory/InventoryManager.ts`) — uses `ox_inventory` resource exports to give/remove items, register stashes, etc.
- **Jobs** (`src/server/config/jobs.ts`, `src/server/managers/JobManager.ts`) — grades, salaries, paychecks, boss permissions, and starter kits
- **Gangs** (`src/server/config/gangs.ts`, `src/server/managers/GangManager.ts`) — similar to jobs, plus territories
- **Events** — server-side `on`/`onNet` listeners and `emitNet` for sending to clients (see `src/server/main.ts` and `src/client/main.ts`)
- **`@/` path alias** — imports look like `@/server/...` / `@/shared/...`, regardless of file depth
- **Light obfuscation** — the build output (`dist/`) is run through `webpack-obfuscator` (hex identifier names, string array), without a heavy performance cost

## Requirements

1. FXServer with the `oxmysql` resource (install and start it before this resource — in `server.cfg`: `ensure oxmysql` before `ensure nc-base`)
2. `ox_lib` and `ox_inventory` resources (for inventory) — download from [overextended/ox_lib](https://github.com/overextended/ox_lib) and [overextended/ox_inventory](https://github.com/overextended/ox_inventory)
3. A MySQL/MariaDB database, `set mysql_connection_string "mysql://user:pass@localhost/database"` in `server.cfg`
4. Node.js + npm/yarn for building

## Installation

```bash
npm install
npm run build
```

This produces `dist/server/server.js` and `dist/client/client.js`, which `fxmanifest.lua` already references.

Import the database schema:

```bash
mysql -u user -p database < sql/install.sql
```

`server.cfg` (order matters — dependencies before this resource):
```
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure nc-base
```

## `@/` path alias

Imports don't use relative paths (`../../shared/types`) — they use the `@/` alias, which points to the `src` folder:

```ts
import { PlayerRow } from '@/shared/types';
import { InventoryManager } from '@/server/inventory/InventoryManager';
```

The alias is configured in two places, and they must match:
- `tsconfig.json` → `compilerOptions.baseUrl` + `paths`
- `webpack.config.js` → `resolve.alias` (since `ts-loader` runs in `transpileOnly` mode, it doesn't read `tsconfig.json`'s `paths` itself — webpack needs to know the alias separately)

## Obfuscation

`npm run build` runs the `webpack-obfuscator` plugin on both the server and client bundles. The configuration (`webpack.config.js` → `obfuscatorOptions`) is intentionally "minimal":

- variable/function names → hex (`identifierNamesGenerator: 'hexadecimal'`)
- string literals hidden in a separate array, base64-encoded
- **disabled**: `controlFlowFlattening`, `deadCodeInjection`, `selfDefending` — these provide stronger protection but noticeably slow down code execution, so they're left off for the sake of FiveM server performance

If you want stronger obfuscation, flip these to `true` in `webpack.config.js` — keep in mind this will make the code run slower.

## ox_inventory support

- `src/server/inventory/InventoryManager.ts` is the single place for all ox_inventory interaction (`addItem`, `removeItem`, `giveItems`, `removeItems`, `canCarryItem`, `getItemCount`, `registerStash`).
- **Starter kits**: `JobGrade`/`GangGrade` (`src/shared/types.ts`) support an optional `items: ItemStack[]` field. `JobManager.hire/fire/promote` and `GangManager.addMember/removeMember/promote` automatically give/remove these items (see examples in `config/jobs.ts` and `config/gangs.ts` — police get a radio + weapon, EMS get bandages, gangs get weapons).
- **Items themselves** (name, weight, icon, etc.) still need to be defined in `ox_inventory`'s own `data/items.lua` file — our config only references item names (e.g. `'radio'`, `'weapon_pistol'`), it doesn't redefine them.
- **Stashes**: `police_armory` is included as an example (registered in `main.ts`'s `onResourceStart` hook), visible only to players with the `police` job at grade ≥ 1. The client can open it with the `/armory` command.
- **Manual giving**: the `nc-base:server:giveItem` net event lets bosses give items directly to a player.

```ts
// Example: give a player an item directly from code (e.g. a quest reward)
InventoryManager.addItem(source, 'lockpick', 3);
```

## Extending

- **New job**: add an entry to the `Jobs` object in `src/server/config/jobs.ts`.
- **New gang**: add an entry to the `Gangs` object in `src/server/config/gangs.ts`.
- **New event**: add an `onNet(...)` listener in `src/server/main.ts` (server) or `onNet(...)` in `src/client/main.ts` (client). To send from server to client, use `emitNet('event:name', source, data)`.
- **New player fields**: extend the `PlayerRow` type in `src/shared/types.ts`, update the SQL schema, and the `Player` class's `toRow()`/constructor.

## Examples of using this from other resources

```lua
-- From a Lua resource
local jobData = exports['nc-base']:GetJob(source)
print(jobData.name, jobData.grade)
```

```ts
// From a TS resource
const gang = (global as any).exports['nc-base'].GetGang(source);
```

## Note

This is a starter kit, not a full solution — things like a UI (NUI menus), voice,
or vehicle ownership are missing. The structure is intentionally simple so you can
quickly build it out to fit your server's needs.
