# Changelog

## Unreleased — documentation refresh

- Customer-first README, guided first catalog and task-based user manual with current real screenshots.
- Expanded API, import/export, recovery, data-location, update and troubleshooting guides.
- Offline customer documentation separated from development reports, roadmap and contribution instructions.
- Public documentation links and a reproducible documentation-only mirror.
- Corrected stale optional-example instructions.

Documentation preparation for a future package. Existing 1.2.0 deliveries/submission remain unchanged; no new version or store availability is announced here.

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
