# Catalog Starter — a guided first catalog

An offline firing range with two weapons, three targets and a score. The catalog supplies names, damage and cooldowns; a small C# component supplies the game rules. UI Toolkit and DataCraft's core JSON dependency are enough. No render pipeline, input package, network account or save file is required.

## 1. Play the included snapshot

1. Choose **Tools → DataCraft → Samples and Quick Start** (or **Explore demos** on Overview).
2. Select **Catalog Starter · Guided first catalog** and **Install / open guided firing range**. Wait for compilation and scene preparation. If you imported through Package Manager, use the same button to prepare its scene.
3. Press Play. Choose **Swift** and click a target: five hits clear its 100 HP. Choose **Heavy**: two hits clear it. Its longer cooldown prevents rapid fire. Each cleared target returns with 100 HP and awards one point. **Reset range** starts over.
4. Expand the code explanation in the game. The catalog read is `selectedReference.Resolve<StarterWeaponData>(catalog)`. Damage and cooldown still need gameplay code to use them.

The sample catalog is an independent snapshot, labelled `DataCraftSampleSnapshot`. Installing it never imports project drafts, overwrites generated project data, writes saves or changes Build Settings. Existing sample folders/scenes are preserved. If a folder already exists without a recognizable script, installation stops and explains the conflict.

## 2. Edit your own drafts and preview a batch

1. Stop Play. Open **JSON Designer → Import template library**. Select `Sources/CatalogStarter.datacraft-library.json` in the installed sample folder. Review the **create new identities** import, then apply. If you already have a template with the same name, use the import's conflict/name options; do not overwrite an unrelated schema.
2. Open the imported **StarterWeapon → Instances**, choose **View → Table**. The Swift and Heavy rows contain `name` (String), `damage` (Int) and `cooldown` (Float). Keep those field names and types for this sample component.
3. **Select page** selects both rows. In **Edit selected instances**, choose **damage**, **Set value**, enter `100`, then commit with Enter or focus change.
4. Choose **Preview selected changes**. Review `20 → 100` and `50 → 100`. Preview writes nothing. **Apply reviewed changes** writes both drafts as one Unity Undo step.
5. Try **Undo**, then **Redo**. Clear text-field focus before using shortcuts if you want to undo the committed draft rather than the text being typed. These buttons use Unity's global history.

Selections may span pages. Search changes clear the selection. A batch changes one field on at most 1,024 explicitly selected instances. Changing its selection, field, operation, value, schema or saved drafts requires a fresh preview. Incomplete drafts can remain, but their blocking errors still prevent export.

## 3. Publish, connect and see the difference

1. Open **Project Data → Validate all**. Correct any blocking project errors. Choose **Update generated output**. This is the boundary between draft edits and the game's read-only snapshot.
2. Duplicate `Scenes/CatalogStarter.unity` into your own scene folder and open the copy. Select **Catalog Starter · guided firing range** in Hierarchy.
3. In **Catalog Starter Demo → Catalog**, assign your project's generated `DataCraftProjectCatalog` from the Project window. Use the asset shown by Project Data; the default is under `Assets/DataCraftGenerated`.
4. For **Swift** and **Heavy**, open the DataCraft reference picker in the Inspector, choose your generated catalog and select the corresponding instance of your imported StarterWeapon template. Import created new IDs: the original sample references do not point to your imported drafts. The picker's catalog locates options; **Catalog** on the component is the catalog resolved at runtime.
5. Press Play and shoot a target: one hit now clears it. If values still look old, verify that you assigned your catalog and its two new references after updating output. Editing drafts alone does not change the included snapshot.

## 4. Make your own script

The supplied `Runtime/StarterWeaponData.cs` was generated from this schema, with its namespace changed to `DataCraft.Samples.CatalogStarter.Generated` to avoid collisions. The automated sample test compares it with the current model generator. Library import does **not** generate scripts.

For your own code, use **Project Data → Generate C# models**, review and explicitly generate. The generated project model is normally `DataCraft.Generated.Models.StarterWeaponData`; name collisions may add a stable suffix. Use the actual previewed type name. Assign a catalog and a `DataCraftTemplateReference` in your component, then:

```csharp
var weapon = selectedReference.Resolve<StarterWeaponData>(catalog);
health -= weapon.damage;
nextShot = Time.unscaledTime + weapon.cooldown;
```

DataCraft handles the catalog lookup and typed JSON mapping, and can generate the model fields. Your component defines how health, firing, scoring and input work. Schema changes require reviewing/regenerating affected project models and adapting gameplay code. This sample intentionally accepts only a non-empty name, positive damage and a finite non-negative cooldown; generic DataCraft Int/Float fields do not enforce those game-specific rules.

## Troubleshooting and build

Select the prepared scene in your own Build Settings to include it in a player. Installation deliberately leaves build scenes unchanged. The copied Panel Settings, theme, stylesheet, font and catalog are scene dependencies; keep them with the demo. No Editor code is used at runtime.

If a reference or weapon is invalid, the game displays an explanation and keeps the last valid weapon. Stop Play to fix the Inspector or data. Installation never replaces an existing prepared scene: to try a clean install, use a separate project or deliberately manage your own sample copy first.

Inter is included under its SIL Open Font License in `Fonts/OFL.txt`.
