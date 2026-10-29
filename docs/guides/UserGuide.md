# Your first game data

[Documentation home](index.md) · Next: [Templates and instances](Authoring.md)

This walkthrough creates two weapons and reads one from a generated catalog in Play Mode. You need an [installed package](../INSTALLATION.md) and a scene. No account or network request is needed.

## 1. Create a template

Open **Tools → DataCraft → Open DataCraft**, then **JSON Designer**. Use **+** or **Create blank template**, depending on the layout. Name the template `Weapon`.

Add two fields with these exact names and types:

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `name` | String | On | Leave disabled |
| `damage` | Integer | On | Leave disabled |

Template edits save automatically. Categories organize the list by icon; they do not change the schema.

![Template metadata and typed fields](Screenshots/docs-first-catalog-wide.png)

*The captured example matches this walkthrough: `Weapon`, with Required `name` and `damage` fields. The category/description are optional organizational metadata.*

## 2. Create instance drafts

In the template's **Instances** area choose **Create**. Name the first instance `Iron Sword`; set `name` to `Iron Sword` and `damage` to `15`. Create `Fire Sword` with `name` = `Fire Sword` and `damage` = `30`.

Enable **Set value** where needed. Zero, false, empty text and unset are distinct states. Resolve the Required warnings before continuing. Instance edits save automatically as Editor drafts.

## 3. Publish the catalog

Open **Project Data**. Review any validation issues and choose **Update Generated Output**, or the initial export action under **Output options · Catalog, C# IDs & models**. The workspace writes to **`Assets/DataCraftGenerated/ProjectData`** automatically; there is no destination dialog. Wait for the export to finish. Expand **Output options · Catalog, C# IDs & models** and choose **Select catalog**, or find `DataCraftProjectCatalog.asset` in that folder in the Project window.

![Project Data output options](Screenshots/models-preview-wide.png)

*The capture shows the separate Signal Salvage example and its model preview. Your walkthrough has only Weapon and two instances. Readiness allows export; output status tells you whether the snapshot is current.*

## 4. Generate the model and read a weapon in Play Mode

In **Project Data → Output options**, choose **Preview C# models**. The preview must contain `WeaponData` with `string name` and `int damage` (the `@` prefix shown in generated C# escapes field names and does not change their names). Choose **Create / Update models** and wait for compilation. Model generation and the Inspector reference picker are available from DataCraft 1.3.0. If you still have 1.2.1, update first or keep your manually maintained DTOs.

Create `Assets/Game/WeaponReader.cs` (create the Game folder if needed), replace its contents with the following code and wait for compilation. Create an empty GameObject and add **WeaponReader**. Assign the generated catalog to **Catalog**, open the **Weapon** reference dropdown, search `Iron Sword` and select the Weapon / Iron Sword row from that catalog. No GUID copying is needed.

```csharp
using DataCraft;
using DataCraft.Generated.Models;
using UnityEngine;

public sealed class WeaponReader : MonoBehaviour
{
    [SerializeField] private DataCraftProjectCatalog catalog;
    [SerializeField] private DataCraftTemplateReference weapon;

    private void Start()
    {
        if (catalog == null || !weapon.IsSet)
        {
            Debug.LogError("Assign the DataCraft catalog and select a weapon.");
            return;
        }
        WeaponData data = weapon.Resolve<WeaponData>(catalog);
        Debug.Log($"{data.name}: {data.damage}");
    }
}
```

Press Play. The expected Console message is **`Iron Sword: 15`**. A missing reference or schema mismatch raises a specific lookup error; use the [Project Data guide](ProjectData.md) to diagnose it. If your Game folder belongs to a custom assembly, add references to `DataCraft.Runtime` and `DataCraft.Generated.Models` in its asmdef.

## 5. Make a change and see the snapshot boundary

Stop Play, change Iron Sword's draft damage to `20`, then open Project Data. It should report that output needs updating. Choose **Update Generated Output**, then enter Play again: the message becomes **`Iron Sword: 20`**.

Without that explicit update, the catalog retains the previous snapshot. Build preflight catches missing, stale, invalid or unreferenced project output; keep the scene's catalog reference and include that scene in your build.

You now have reusable definitions. For coins/checkpoints or an equipped weapon ID, follow [Local saves](SavesAndFiles.md). For Enums, lists and linked enemies, continue with [Templates](Authoring.md) and [Project Data](ProjectData.md), or play [Emberfall](Examples.md).
