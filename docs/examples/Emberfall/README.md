# Emberfall — playable DataCraft example

Open **Tools > DataCraft > Samples and Quick Start > Install / open Emberfall**, then press **Play**. The installer copies this optional sample, including its separate catalog and prepared `Scenes/Emberfall.unity`. Package Manager sample imports include the same prepared scene; the menu opens it and can prepare one if missing. Requires Universal RP, Unity UI and Input System. See the package Compatibility guide for the exact tested Editor/renderer/backend combinations.

## Play and follow the data

1. **Iron Sword / 20 damage** is read with `catalog.Get<WeaponDto>(templateId, instanceId)` from the scene's serialized catalog. No Resources lookup or Editor dependency is needed at runtime.
2. **Switch equipment** calls `GetAll<WeaponDto>`. Fire Sword changes damage, weight, rarity, Element and ordered tags; its rune light becomes warm. Lists are independent game values; changing one DTO does not edit the catalog.
3. **Resolve Goblin → weapon** reads an Enemy DTO and calls `enemy.weapon.Resolve<WeaponDto>(catalog)`. The reference points to Iron Sword's stable identity, rather than duplicating its damage.
4. **Save checkpoint** writes current coins and equipment through `DataCraft.Save<PlayerState>` using only `datacraft_sample_emberfall`.
5. **Spend coins** changes memory from 42 to 0. The stored checkpoint is unchanged. Switch equipment as well to demonstrate the separation.
6. **Load checkpoint** reads the file and restores the saved coins and equipment. **Inspect checkpoint JSON** displays the loaded state serialized as a DataCraft envelope; it is an inspection, not an editable raw-file view.
7. Stop Play and open **Tools > DataCraft > Local Save Files**. Refresh, select the sample save, inspect its envelope and path. **Edit JSON > Save with backup** can change `value.coins` while retaining the original backup. Backups are manual recovery copies, not automatic restore. On re-entering Play the live wallet starts at 42; press Load to read the edited checkpoint.

Startup never writes or deletes a save. Existing checkpoint errors are visible rather than silently reset. The generated world and HUD are created in Play; their material/font references are part of the scene/sample. Use a 16:9 Game view to match the trailer framing; the Canvas expands to keep the entire design visible at other aspect ratios.

## Authoring → catalog → game

The sample includes `Sources/Emberfall.datacraft-library.json`: **Weapon + Enemy**, two weapons and two enemies, with Enum, List and Reference definitions. Import it with **JSON Designer > Import / Export > Import template library**. Review names and dependencies before committing; import creates **new identities**, never merges into or replaces an existing template.

1. Select the imported Weapon. Change Fire Sword's damage, edit its Enum/tags, or add a weapon. Required/type diagnostics explain invalid drafts.
2. Open **Project Data**, review readiness and choose **Update Generated Output**. This is an explicit read-only snapshot; authoring autosave does not update it.
3. Duplicate the sample scene before connecting your own data. On its CampDemo component assign the newly generated catalog, copy Weapon's template ID, Iron Sword's instance ID, Enemy's template ID and Goblin's instance ID into the corresponding fields. Do not reuse the example's original IDs after importing its library.
4. Press Play. The same DTOs now read your own snapshot. Changing the authoring value alone leaves the prior snapshot unchanged until you regenerate it.
5. Project Data can generate optional **C# ID constants**. A custom asmdef must reference DataCraft.Generated to use them. This sample keeps IDs serialized so its runtime assembly does not depend on generated code.

## JSON / CSV and transfer exercises

- `Sources/weapons.json` and `weapons.csv` contain the same rows. In the existing Weapon template, **Import / Export instances (JSON / CSV)** maps columns to fields. Enum uses exact symbols (`Physical`, `Fire`); tags use JSON arrays, including quoted arrays in CSV. Create new is the default: use a duplicate/empty practice template for this exercise. Reviewed keyed updates are available when a compatible mapped String/Integer key is configured.
- `Sources/enemies.json` uses exact destination names (`Iron Sword`, `Fire Sword`). Import weapons first; Interchange resolves existing references and does not create dependencies automatically.
- Save/apply a mapping profile; JSON collection paths select an array using JSON Pointer. Reviewed update-existing/create-or-update modes and explicit URL/API acquisition are available. Automatic synchronization is not provided; review the mapping/mode before applying.
- Export the two linked templates as an **Authoring Library** and import it into another project. Library transports definitions, drafts and their internal links with new IDs. Flat JSON/CSV moves rows; Project Data is a runtime snapshot; player Save/Load is separate.
- Creating a template from CSV/JSON initially infers primitives. Configure Enum/List/Reference explicitly in the review/Designer; nested objects and nested Lists are not supported authoring fields.

## Isolation and builds

The prepared sample catalog lives under this sample's `Catalog/`, independently of `Assets/DataCraftGenerated/ProjectData`. Installation does not modify ProjectSettings/DataCraftTemplates.asset, DataCraftInstances.json, your build scenes, render pipeline or input settings. It does not include the trailer's recording watchers, auto-fit reflection, test commands or private project data.

For a sample-only Player, add the prepared scene explicitly to Build Settings and keep Universal RP configured. Its validated catalogue is labelled `DataCraftSampleSnapshot`. Existing project-owned authoring/output must still pass normal DataCraft preflight; the sample label cannot bypass those checks. Shader reference is serialized for build inclusion. Platform/backend evidence is in the package's review report; do not infer untested Player support from an Editor Play demo.

## Files and third-party notices

`Runtime/CampDemo.cs` is the public API example; `CampDemo.World.cs` builds the original geometric camp. Inter is included under the SIL Open Font License; see `Fonts/OFL.txt`. Geometry and effects use Unity primitives and sample-owned code, without an external model/effects library.


Build verification depends on the reviewed source/Editor/backend. See the package Compatibility guide rather than inferring current platform support from an older sample pass. Keep the prepared scene's fog/shader references for Player builds.
