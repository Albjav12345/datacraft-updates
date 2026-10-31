# Changelog

## Unreleased

No changes recorded.

## 1.4.1 — Aligned table grid · 2026-10-31

- Align typed inputs, identities and headers to a shared grid with uniform row surfaces and column dividers.
- Use the Cards Previous/Next controls for table and bulk-review pages. Select visible fields separately through Columns.


## 1.4.0 — Table authoring, native Undo and a guided first catalog · 2026-10-30

Prepared for release. Download availability follows each store independently. Includes the catalog models, Inspector references and bounded update history from the internal 1.3 milestone.

- Refine Table with consistent vector icons, descriptive tooltips, quiet Undo/Redo and selection actions, compact row editing, grouped navigation chevrons and selection-only bulk controls. Keep Cards action buttons square, dropdown labels aligned and the narrow template toolbar wrapped without clipped actions.
- Add a responsive instance Table alongside Cards: eight rows per page, width-dependent field columns, inline typed values, readiness, search and view-only name sorting.
- Add explicit selected-row bulk editing of one field with a frozen paginated before/after review, stale-plan checks and atomic apply. Preserve IDs/order/other fields; allow incomplete drafts with clear export blockers.
- Add native Unity Undo/Redo for committed instance edits, instance-only imports/updates, draft schema review and one-step bulk changes. Scope history to the open workspace and clear incompatible snapshots safely after schema changes or coordinated imports.
- Protect ordinary instance writes from external file replacements/read-only failures, restoring in-memory data and showing actionable feedback in Cards and Table.
- Add the offline Catalog Starter firing range, a guided table → bulk → Undo/Redo → publish → gameplay path and a concrete typed-code explanation. Uses UI Toolkit and the core JSON dependency, with no renderer/input/network requirement.
- Expand Authoring, Examples, README and offline Help to explain selection scope, draft/publication boundaries, history lifetime and the guided sample.

## 1.3.0 — Typed catalog models and Inspector references · 2026-10-29

Internal prepared milestone; its features are included in 1.4.0. Store availability is separate.

- Keep catalog/ID/model output labels visible in compact Project Data layouts, and stack narrow output buttons at a consistent height.

- Bound the Settings release history to a 320 px reading area with its own vertical scroll and foldout. Long histories no longer stretch the settings page indefinitely.

- Align reference labels and input slots through Unity’s native Inspector field layout instead of calculating a separate IMGUI label column; reference list rows share the normal field column.

- Use Unity’s native object-field styling and a small cyan DataCraft icon for Inspector reference selectors, including list elements and mixed values. Preserve standard prefab override indicators.

- Keep Inspector reference list row labels readable after assignment instead of exposing serialized template IDs.
- Revoke reviewed model previews when output becomes conflicted, show recovery instructions, and require a fresh preview after recovery. Mark schema-invalidated previews as errors.

- Clarify partial keyed-import mapping summaries: matched rows keep unmapped required values; only newly created rows need those fields supplied. Existing row validation still blocks invalid data.

- Keep generated C# ID/model ownership valid after LF/CRLF conversion by Git or an editor. Content modifications still block overwriting; unchanged generation preserves the original bytes.

- Add optional, schema-based catalog C# model and Enum generation with a read-only preview, explicit creation/update, freshness checks and checksummed ownership protection. Generated partial classes keep exact field names, Enum codes and preserved reflected members; custom code belongs in separate files.
- Add a searchable Inspector picker for Template References, using exported catalog instances and stable IDs, with explicit clearing, missing-reference feedback, multi-object editing, prefab overrides and Unity Undo. An optional `DataCraftReferenceTarget` attribute restricts Inspector choices to a template; generated reference fields include it.
- Show stale opted-in models in Project Data/Designer and reject a Player build until those models are reviewed and updated. Catalog/ID updates never silently regenerate model code.
- Simplify the first-catalog walkthrough to generate models and select a weapon by name in Inspector. Existing manually maintained DTOs and serialized catalog/save formats remain supported.

- Corrected UTF-8 separators in the three Package Manager sample display names. Published 1.2.1 archives remain unchanged.

## 1.2.1 — Documentation and reliability · 2026-10-28

Published on itch.io on 2026-10-28. Unity Asset Store availability follows its separate review; this release is not announced as available there.

### Documentation

- Reorganized the README and offline Help around the tasks a new user needs: first catalog, authoring, imports/exports, player saves and HTTP APIs.
- Added a step-by-step first-catalog walkthrough, clearer expected results, data locations, recovery guidance and current real Unity screenshots.
- Expanded API, transfer, update and troubleshooting guides; corrected optional-example instructions and automatic output paths for Project Data and generated API code.
- Separated customer guides from maintainer reports and made the public documentation mirror reproducible and self-contained.

### Fixes

- Accept exactly representable large integer values in Float imports and preserve them in Float-list/template transfer round trips.
- Avoid generated instance ID constants colliding with their enclosing template class, including when a template and instance share a name.
- Reject special C# field keywords, the reserved Enum option `value__`, and the API client name `FetchAsync` before they produce invalid generated code.
- Reject malformed JSON Unicode escapes and unmatched surrogate pairs consistently in authoring imports.
- Prevent installing/opening Stratus during Play Mode before copying files or replacing the scene.

### Generated credential handling

- Detect sensitive API-key/token query names even when their placeholder uses a generic alias, so generated gameplay components do not expose these values as serialized Inspector fields. Supply credentials at runtime.
- If an earlier generated component serialized a credential, remove that value from project assets/history as appropriate and rotate the credential if it was shared. This fix does not automatically rewrite existing generated scripts.

Runtime APIs, existing IDs and serialized save/catalog formats are unchanged. Existing projects do not require a data migration. Back up before updating and regenerate affected ID/API code when relevant. Optional examples retain their documented additional requirements.

## 1.2.0 — Updates through your purchase store

Unity submission packaging revision r2: normalized script line endings and added a release preflight guard. Official static/dependency warnings have a documented native review; this revision adds no functional Runtime or authoring changes. The earlier signed itch.io archive remains unchanged.


- Separate Asset Store and itch.io editions: each shows its own release history, availability and update action, without a customer store selector.
- Asset Store customers open DataCraft directly in Unity Package Manager; Unity manages purchase access and available package versions.
- itch.io customers sign in through their browser using OAuth with PKCE. Official purchases, gifts, bundles and publisher-authorized access are checked by itch.io before downloading.
- One Update action downloads the authorized file, checks signed release hashes, validates the package and installs through UPM. No silent background installations.
- Retain the previous package for explicit restoration. Project-local archives use portable relative references; authoring data and game saves remain separate.
- Optional secure device sessions on Windows/macOS; session-only fallback when secure storage is unavailable. No passwords, tokens or project data are sent to the release metadata host.
- Publisher-signed release notes inside the Editor: features, fixes, security advisories, affected versions, Unity requirements and normal/recommended/critical importance.
- Manual checks, optional daily checks, offline/cached status, tamper/rollback detection and a 24-hour reminder.
- Polished notice spacing, account progress and actionable access diagnostics. Runtime APIs, existing IDs and serialized formats are unchanged.

First public Asset Store delivery; itch.io users upgrading from 1.1.1 install the new signed tarball once to obtain this updater. Later supported itch.io releases can be installed through Settings > Updates after explicit confirmation. Store publication/availability is announced only after each store actually offers the release. This updater does not encrypt game JSON or provide anti-cheat protection.

## 1.1.1 — Initial itch.io public release

- Visual JSON Designer with primitive fields, Enums, ordered Lists and stable Template References.
- Instance authoring with validation, optional defaults and explicit unset values.
- JSON/CSV import/export, template creation from files, portable template packages and multi-template libraries.
- Reviewed schema migration, reusable mappings and keyed updates for authoring drafts.
- Generated read-only Project Data catalogs, stable C# IDs and build validation.
- Build-safe local JSON Save/Load and reviewed file inspection/editing with original backups.
- HTTP JSON workflows with reusable endpoint assets and reviewed typed DTO/client and gameplay code generation.
- Optional project-local Codex and Claude Code skill: six guides and three C# examples.
- Responsive Editor workspace, searchable offline Help, installed-version details and support contact.
- Three optional examples: Emberfall, Stratus and Helio.
- Minimum Unity 6.0 LTS 6000.0.85f1; verified core Editor suites on 6000.0.85f1, 6000.3.27f1 and 6000.5.5f1.

Optional examples have additional dependencies documented in their setup guides. AI assistants and external API services are provided separately. The original release used legacy release checks without the signed history/severity UI introduced in 1.2.0. The legacy channel now points to the actually available itch.io version; updates are installed explicitly.

Earlier 1.0/1.1.0 submissions and internal candidates were not public releases. Historical development verification remains in the dated technical documentation.

### Optional demo compatibility

Emberfall is verified on Unity 6000.0.85f1 with URP 17.0.4. In the tested 6000.3.27f1 installation, bundled URP 17.3.0 fails compilation because of missing Unity script metadata; Emberfall is not certified with that combination. Core DataCraft and Stratus/Helio pass on 6000.3.27f1. See the compatibility report.
