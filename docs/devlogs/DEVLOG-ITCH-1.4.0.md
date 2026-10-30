# DataCraft 1.4.0 — Review data in a table, undo changes, see them in play

DataCraft 1.4.0 makes larger catalogs easier to edit and gives new users a small playable example that connects authoring to gameplay. It also includes the model-generation and Inspector improvements prepared during the internal 1.3 milestone.

## Edit instances together

- A cleaner Table interface with quiet vector icons, hover descriptions, compact row actions and evenly grouped navigation. Bulk controls appear when rows are selected.
- Switch between Cards and a responsive Table with typed values, search, view-only name sorting and eight rows per page.
- Select rows across pages and edit one field for up to 1,024 instances at once.
- Preview the complete batch before saving. Paginated reviews show before/after values and remaining export blockers; stale reviews cannot apply.
- Apply the batch as one Unity Undo step while preserving identities, order, other fields and unselected rows.

## Native Undo and clearer boundaries

Committed instance edits now participate in Unity Undo/Redo, including instance-only import/update, draft schema review and bulk changes. History lasts for the open workspace session; incompatible schema changes and coordinated imports clear or rebase it safely. External-file and read-only failures preserve the existing draft data and explain how to recover.

Undo changes drafts. Updating the game's generated catalog remains an explicit Project Data action. History is not a durable backup or a player-save migration system.

## Play the new Catalog Starter

Open Tools → DataCraft → Samples and Quick Start. The offline firing range ships ready to play: Swift and Heavy get damage and cooldown from a typed catalog model.

The walkthrough then takes you through importing its library, reviewing a damage change in Table, trying Undo/Redo, publishing your catalog and assigning it to a duplicate scene. One hit now clears a target. An in-game explanation shows the small typed data-access code and the gameplay rules that remain yours to write.

Catalog Starter uses UI Toolkit and the core JSON dependency. It needs no render pipeline, input package, network account or save file. Its shipped snapshot stays separate from your project's drafts and generated output.

## Also included since 1.2.1

- Optional C# partial model and Enum generation, with code preview, ownership protection and freshness/build checks.
- Searchable Unity-style Inspector reference pickers, including lists, multi-object editing and prefab overrides, identified by a small cyan DataCraft icon.
- Clearer model conflicts, partial-import summaries and compact Project Data controls.
- A bounded, independently scrolling release history in Settings.
- Updated beginner guides, searchable offline Help and real Unity screenshots.

Existing manual DTOs, stable IDs and save/catalog formats remain supported. Back up your project before upgrading. Generate models explicitly, keep custom partial members in separate files and review your own code after generated type renames.

Store availability is managed independently for itch.io and Unity Asset Store. Publishing this devlog does not itself announce an in-Editor update; the exact uploaded download must be verified first.
