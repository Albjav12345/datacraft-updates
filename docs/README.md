# DataCraft

![DataCraft](guides/Branding/DataCraft-lockup-dark.png)

**Design game data, save player progress and use JSON APIs in Unity.**

**Version 1.3.0 — typed catalog models and Inspector references.** Generate C# classes from your templates and choose authored instances by name in the Inspector. [Read the changelog](CHANGELOG.md). Store availability follows the announcements for your purchase edition.

DataCraft brings these workflows into one Editor workspace. Define typed templates and instances, publish a read-only catalog for gameplay, save mutable progress locally, or turn an HTTP JSON response into reviewed C# code.

**Start with [Installation](INSTALLATION.md), then follow [Your first game data](guides/UserGuide.md).** Open **Tools → DataCraft → Open DataCraft** after installation. The **Help** tab is searchable and works offline.

![The DataCraft workspace](guides/Screenshots/ux-overview-wide.jpg)

*Overview connects the main workflows. Screenshots show example projects, not data automatically added to yours. Click an image to view it at full size.*

For example, define a Weapon template once, generate `WeaponData`, then select Iron Sword on a component and read its damage in gameplay. You maintain the template fields; DataCraft keeps the reviewed C# model in step with that schema. Existing manual DTOs remain supported. Version 1.3.0 is prepared for release; check your store for actual download availability.

## Choose your workflow

| I want to… | Start here |
| --- | --- |
| Define weapons, enemies, items or configuration | [First catalog walkthrough](guides/UserGuide.md) → [Templates and instances](guides/Authoring.md) |
| Read authored data from my game | [Project Data and typed lookup](guides/ProjectData.md) |
| Bring in a spreadsheet or move linked templates | [Import and export](guides/ImportExport.md) |
| Save/load a player's progress | [Local saves and Files](guides/SavesAndFiles.md) |
| Fetch an API or map ordinary JSON to C# | [HTTP JSON and generated clients](guides/HttpApi.md) |
| Try a complete working scene | [Optional examples](guides/Examples.md) |
| Update my purchase or recover an installation | [Updates by store](guides/Updates.md) |

## Keep the three kinds of data separate

| Data | Edited in | Used by |
| --- | --- | --- |
| Templates and instance drafts | JSON Designer | Editor authoring |
| Generated catalog and shards | Explicitly updated in Project Data | Read-only gameplay definitions |
| Local JSON saves | Your game's Save/Load calls; Files can inspect/review edits | Mutable player progress |

Editing a draft does not update a built game's catalog. Loading a player save does not import a template. An API response is ordinary JSON; it is separate from the DataCraft save envelope.

## Included workflows

- Typed fields: String, Integer, Float, Boolean, Enum, ordered List and Template Reference.
- Instance validation, explicit unset/default values and reviewed Editor schema changes.
- JSON/CSV row transfer, saved mappings, keyed updates and portable template libraries.
- Generated Project Data catalogs, stable IDs, optional C# ID constants, reviewed C# models/Enums, Inspector reference selection and build preflight.
- Build-safe local Save/Load; local file inspection and reviewed edits with original backups.
- HTTP JSON requests, saved endpoints, DTO/client previews and optional gameplay generation.
- Optional project-local Codex/Claude Code instructions and three playable examples.
- Edition-specific update information and searchable offline Help.

## Requirements and documentation

Minimum Editor: **Unity 6.0 LTS 6000.0.85f1**. Package: **`dev.amedina.datacraft`**. Unity resolves the core JSON/network dependencies during UPM installation. Optional sample requirements and exact tested configurations are listed in [Compatibility](guides/Compatibility.md).

The shipped package's guides describe that installed version. Online guides can receive corrections ahead of the next package. See **Settings** for your installed version and **Settings → Updates** for availability in your purchase store; store review and publication can happen at different times.

[All user guides](guides/index.md) · [API reference](guides/ApiReference.md) · [Troubleshooting](guides/Troubleshooting.md) · [Changelog](CHANGELOG.md)

Questions or feedback: **[amedina.amg.dev@gmail.com](mailto:amedina.amg.dev@gmail.com)**. [What to include in a report](SUPPORT.md).
