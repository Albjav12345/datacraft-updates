# Troubleshooting

[Documentation home](index.md) · [Contact support](../SUPPORT.md)

Start with **Settings → Copy version details** and the first relevant Console message. Work on a backed-up/disposable project when diagnosing recovery or installation.

| Symptom | Check first |
| --- | --- |
| DataCraft does not compile/open | Wait for Package Manager resolution; inspect its dependency/network error and Console. Keep one tool installation. Core UPM resolves JSON/network requirements automatically. |
| Duplicate assemblies/assets | An old `Assets/DataCraft` copy or duplicate sample may coexist with UPM. Follow [backed-up migration](../INSTALLATION.md). |
| DataCraft is missing in Package Manager | Clear search/filter; select the project/installed package list. Verify identity `dev.amedina.datacraft`. |
| Catalog shows old values | Draft edits do not publish output: review Project Data and explicitly update it. |
| Build preflight blocks | Follow the reported draft, freshness, validity or build-reference issue; do not bypass the check. |
| Lookup cannot find an instance | Assign the correct catalog; use real template/instance IDs. Imports create new identities. |
| DTO mapping fails | Match exact field names/types, Enum names/codes and List/reference contracts. See [Project Data](ProjectData.md). |
| New/removed/type-changed fields need attention | Review schema changes, bind/reset/convert/unset explicitly and retain the original backup. |
| Template editing is paused after save failure | Use the visible recovery actions; export unresolved edits before closing/deleting Library. |
| Import has ignored columns/errors | Review destination schema, Instance name mapping, types, Required values and diagnostics. The whole batch must be valid. |
| Keyed update refuses duplicates | Keys must be unique and match the selected String/Integer policy. Display names are not automatic keys. |
| Local save is missing in Files | Compare actual `StorageDirectory`: Editor, app identity and devices have different paths. Refresh after external writes. |
| Load fails on an existing file | Preserve it. Distinguish missing file, invalid envelope, wrong root type and permission failure. Do not broadly catch and overwrite. |
| Web save disappears after reload | Enable/test persistent-data synchronization in the selected [Web template](WebPersistence.md); preserve origin/path. |
| API request fails | Inspect failure/status, HTTPS URL, parameters/headers, deadline/size and provider availability. Browser CORS is separate from Editor success. |
| API code compiles but mapping is wrong | Review provider schema/nullable cases, response JSON Pointer and DTO attributes; validate before gameplay. |
| Example is unavailable or does not compile | Check its optional requirements and exact [compatibility boundaries](Compatibility.md). Do not add demo dependencies just to use core DataCraft. |
| itch.io connected but no access | Claim/link the official purchase/gift/bundle to that account, then Verify access. Connection does not grant ownership. |
| Browser login returned but connection failed | Read the phase/diagnostic; retry once or use the one-time-code flow. Never share codes/tokens in support reports. |
| Update verification/download failed | Keep the installed package. Check the displayed phase/network/hash error; do not repack files or disable signature checks. |
| Update installed but reload is incomplete | Wait for compilation; inspect Console/status. Use retained archive restoration if needed. |
| A version exists in another store only | Your edition follows its own store availability and entitlement. A pending review is not a downloadable Unity release. |
| Offline/stale update status | Saved verified information is labelled. Check dates and the purchase store; it is not a fresh current result. |

If the problem persists, send a minimal reproduction and version details to **[amedina.amg.dev@gmail.com](mailto:amedina.amg.dev@gmail.com)**. Exclude API keys, tokens, private saves, download keys and signing keys. [Support checklist](../SUPPORT.md).
