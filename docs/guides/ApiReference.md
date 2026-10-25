# Runtime API reference

[Documentation home](index.md) · [Catalog walkthrough](UserGuide.md) · [Local saves](SavesAndFiles.md) · [HTTP JSON](HttpApi.md)

These are public runtime entry points. Editor authoring stores/export services are not a public runtime API. Import the `DataCraft` namespace; use `using Storage = DataCraft.DataCraft;` for local storage to avoid the namespace/type name overlap.

## Local JSON saves

| Member | Behavior |
| --- | --- |
| `Storage.Save<T>(string name, T value, bool overwrite = true)` | Write a Unity-serializable value in the versioned save envelope |
| `Storage.Load<T>(string name)` | Read the exact declared root type |
| `Storage.Exists(string name)` | Check file presence, without locking |
| `Storage.Delete(string name)` | Delete directly; return whether a file existed |
| `Storage.GetPath(string name)` | Validate a logical name and return its JSON path |
| `Storage.StorageDirectory` | `Application.persistentDataPath/DataCraft` |
| `DataCraftJson.Serialize<T>(T value, bool prettyPrint = false)` | Make a save-envelope string without writing a file |
| `DataCraftJson.Deserialize<T>(string json)` | Read the save envelope, not arbitrary external JSON |

Missing file: `FileNotFoundException`. Wrong root type: `InvalidCastException`. Invalid envelope: `FormatException`. Unsupported serializable contract: `NotSupportedException`. Invalid names: `ArgumentException`. IO/permission failures remain possible. Runtime Delete does not provide the Editor's review/backup UI.

## Generated Project Data

| Member | Behavior |
| --- | --- |
| `catalog.Get<T>(string templateId, string instanceId)` | Map a new DTO from one authored instance |
| `catalog.GetAll<T>(string templateId)` | `IReadOnlyList<T>` in saved instance order |
| `DataCraftTemplateReference.TemplateId / InstanceId / IsSet` | Inspect a stable authored handle |
| `reference.Resolve<T>(DataCraftProjectCatalog catalog)` | Explicitly resolve that handle |

Lookup errors: `DataCraftProjectDataNotFoundException`, `DataCraftProjectDataFormatException`, `DataCraftProjectDataMappingException`. Reference resolution also rejects an unset handle or null catalog. Read the [DTO mapping contract](ProjectData.md) before adding Enum/list/reference members.

## Ordinary JSON and HTTP

| Entry point | Purpose |
| --- | --- |
| `DataCraftRawJson.Deserialize<T>(json)` | Map ordinary JSON using the external-JSON DTO contract |
| `DataCraftRawJson.Serialize(value)` | Produce ordinary JSON, such as a request body |
| `DataCraftRawJson.Select(json, jsonPointer)` | Select an exact JSON subtree |
| `DataCraftApi.GetAsync<T>(url, options, cancellationToken)` | Typed GET |
| `DataCraftApi.SendAsync<T>(request, options, cancellationToken)` | Explicit method/body request |
| `DataCraftApi.RequestAsync(request, options, cancellationToken)` | Response object for explicit handling/deserialization |
| `endpoint.SendAsync<T>(parameters, headers, jsonBody, cancellationToken)` | Apply a saved endpoint and its response path |
| `endpoint.RequestAsync(parameters, headers, jsonBody, cancellationToken)` | Response object from saved configuration |

`DataCraftApiRequest` supplies `Url`, `Method` (`DataCraftHttpMethod`) and `JsonBody`. `DataCraftApiOptions` supplies `TimeoutSeconds`, `MaxResponseBytes` and per-call `Headers`; defaults are 15 seconds/2 MiB. `DataCraftApiResponse` exposes `StatusCode`, `Json`, `HasBody` and `Deserialize<T>(responsePath)`.

`DataCraftApiException.Failure` distinguishes `Connection`, `Http`, `Timeout`, `ResponseTooLarge` and `InvalidResponse`; `StatusCode` supplies the HTTP status when present. Caller cancellation raises `OperationCanceledException`. Invalid arguments/configuration are separate. No automatic retry policy is supplied.

External-JSON DTOs support fields/properties, nested objects, arrays/lists/dictionaries and JSON.NET attributes. This is a different contract from both local-save serialization and catalog field mapping. Preserve reflected members and required generic instantiations for the shipping AOT/stripping configuration.
