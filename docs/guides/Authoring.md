# Templates and instances

[Documentation home](index.md) · [First catalog walkthrough](UserGuide.md) · [Project Data](ProjectData.md)

A **template** defines fields. An **instance** is a named draft of values for those fields. JSON Designer saves both as project metadata; your game reads a separate generated catalog.

## Find and organize templates

Create a blank template with **+** or the empty-state action. Edit its name, category and description. Search by name. The list and selected header share a category icon. Narrow layouts use a template picker instead of the sidebar.

**Actions** groups duplication, Copy ID, reordering and schema review. Duplicate makes a new identity; rename/reorder retains the existing identity. Deleting a template does not silently delete its instance drafts. Review orphaned drafts on Project Data before explicitly removing them.

![Designer at a compact dock width](Screenshots/docs-first-catalog-compact.png)

*The same workflow adapts to a docked window. Captured template names and counts are example project data.*

## Define fields

Use unique C#-style names: ASCII letter/underscore first, then letters, digits or underscores. Names are unique ignoring case; reserved C# keywords, including the special `__arglist`/`__makeref`/`__reftype`/`__refvalue` forms, are rejected. Field IDs stay stable when a name changes.

| Type | Values and rules |
| --- | --- |
| String | Text, including an explicitly set empty string |
| Integer | 32-bit integer |
| Float | Finite 32-bit value; use a dot decimal separator |
| Boolean | Set true/false; unset is a separate state |
| Enum | One named option with a stable Int32 code; no Flags |
| Template Reference | Stable link to an instance of the chosen target template |
| List | One ordered level of a supported scalar/Enum/reference type |

**Use default value** stores a default; it does not make a field Required. **Required when creating an instance** adds draft validation. Required Strings cannot be empty or whitespace-only. Required lists need at least one element. Defaults are copied for new bindings/instances; changing a default does not rewrite existing values.

### Enum options

Add named options, then choose a default if needed. Renaming/reordering preserves each option's numeric code. **Edit codes (advanced)** exposes numeric editing; use deliberate stable codes for game C# Enums. Removing an option leaves affected values unresolved until corrected. The name `value__` is reserved by C# for Enum storage and cannot be an option. There are at most 128 options, paged eight at a time.

### Lists and references

Lists preserve order and distinguish unset from explicit `[]`. They allow at most 1,024 elements and 1 MiB per list. Nested lists, null elements and arbitrary object lists are unsupported.

For a reference choose **Target template**, then a destination instance. Renaming/reordering keeps the link. Deleting a destination preserves the binding and reports an error. Changing the target does not convert old links automatically. Self-references/cycles are supported and resolve explicitly at runtime.

## Edit instance drafts

Choose **Instances → Create**, enter a unique instance name, then expand its row. **Set value** controls presence; enabling a Boolean's value is separate from setting it true. Search and pagination help with larger datasets. Clear a search before reordering; deletion requires confirmation. A single-instance template allows one draft.

Validation stays next to the affected values. You can retain incomplete drafts, but blocking errors prevent Project Data export. Bind a newly added field explicitly; a removed field's old binding remains stored until explicitly removed.

## Review an existing schema change

1. Select the template and choose **Actions → Review schema changes**.
2. Inspect the bindings against the saved schema. Every choice begins as **Keep unchanged**.
3. Choose supported conversions, current-default resets, unset, binding new fields or explicit removal of obsolete values as appropriate. Lists/reference targets are not guessed.
4. Review selected changes, confirm and use **Apply with backup**. A schema/draft/file change invalidates an old review.
5. Correct remaining errors and explicitly update generated output.

Original draft bytes are retained under `ProjectSettings/DataCraftMigrationBackups`. This affects Editor drafts only, not player saves, API DTOs or generated game data. Review limits are 10,000 project instances, 10,000 bindings and 32 MiB drafts. There is no automatic backup pruning or crash/power-loss certification.

## Saving, Undo and recovery

Ordinary template edits use Unity Undo/Redo in the current Editor session. Instance edits, imports, generated output and player saves are outside that history. Imports reset template history to avoid undoing only half of a two-store import.

If an ordinary template save fails, editing pauses and offers **Retry edit**, **Export recovery**, **Discard edit** and **Reload from disk**. Preserve a recovery export before closing when the journal cannot be written. Do not delete `Library` while template recovery is unresolved. See [Data locations and backups](DataAndBackups.md).
