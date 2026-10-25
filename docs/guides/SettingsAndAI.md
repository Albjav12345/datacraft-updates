# Settings and optional AI integration

[Documentation home](index.md) · [Updates](Updates.md) · [Support](../SUPPORT.md)

## Version, preferences and locations

Settings begins with the installed DataCraft version, package identity/source, actual Unity Editor and declared minimum. **Copy version details** prepares a path-free support summary. A local archive's version is not proof that every later Unity configuration was tested; see [Compatibility](Compatibility.md).

Choose the workspace start page for this user/project or reset to Overview. Direct Tools menu entries still open their named destination. Location details distinguish authoring drafts, generated output, Editor-local saves and file backups. Reveal opens existing locations; it does not relocate storage.

Update checks, release history, account access and package recovery are covered in [Updates](Updates.md).

## Install assistant instructions only if you use them

**Settings → AI integration** installs the bundled `datacraft` skill for **Codex** or **Claude Code** into this project's `.agents/skills/datacraft` or `.claude/skills/datacraft` folder. Installation is explicit and offline. The main SKILL file routes to six task guides and three C# examples:

| Guide | Focus |
| --- | --- |
| Setup and diagnostics | Find the real installation, compilation and update diagnostics |
| Authoring and interchange | Schema, imports/exports, keys and identities |
| Local saves | Save DTO contracts and deliberate recovery |
| Project Data | Catalog/DTO matching, references and builds |
| HTTP JSON | Endpoints, credentials, cancellation and typed mapping |
| Gameplay integration | Separate authored definitions from player state |

Invoke `datacraft` in the assistant; reload its skills if needed. **View skill files** opens the source instructions. Existing assistant rule files, unrelated skills and locally edited instructions are preserved.

This supplies guidance against DataCraft's installed API. It is not an AI subscription, hosted service or Unity control bridge. The assistant is separate software; review its proposed code and run the relevant gameplay/build checks. Keep private tokens and production saves out of prompts and reports.
