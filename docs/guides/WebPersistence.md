# Persistent saves in Web builds

[Documentation home](index.md) · [Local saves](SavesAndFiles.md)

Unity's virtual filesystem can accept a write without storing it in the browser's IndexedDB database. Loading the file in the same session does not prove that it will survive a page reload.

For Unity 6000.5.5f1, enable automatic persistence in the Web template, before calling `createUnityInstance`:

```javascript
config.autoSyncPersistentDataPath = true;
```

The default template includes this line commented out. For a repeatable shipping build, copy Unity's Default Web template into your project's `Assets/WebGLTemplates`, enable the line in that copy and select the custom template in Player Settings. Changing only an exported `index.html` affects that export; a subsequent build can overwrite the change. DataCraft does not change the consuming project's template automatically.

The 2026-10-22 review reproduced loss of a DataCraft save after reload with the default setting. With automatic synchronization enabled, a second launch recovered the same unique save token. The same application passed 48/48 checks in the actual browser, including catalog references/lists, atomic replacement and HTTP operations. See [tested compatibility boundaries](Compatibility.md).

Synchronization is asynchronous. Returning from synchronous `Save` does not promise that the browser has finished committing IndexedDB. This review waited for normal completion before reloading; it does not certify immediate tab termination, power loss, quota exhaustion or private browsing. Keep the same origin and application URL directory; changing the hosting path can change Unity's persistent-data location. Clearing site data removes browser saves.

External JSON services must allow the web application's origin through CORS. A successful native request does not establish browser access. The test used a controlled loopback fixture and a public CORS-enabled HTTPS endpoint; it does not certify arbitrary providers.

Unity reference: [Web template configuration](https://docs.unity.com/en-us/engine/6000.0/manual/platform-specific/webgl/building-distribution/templates/web-templates-build-configuration).
