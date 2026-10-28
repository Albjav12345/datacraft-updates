# Changelog

## Unreleased

No changes recorded after 1.2.1.

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
