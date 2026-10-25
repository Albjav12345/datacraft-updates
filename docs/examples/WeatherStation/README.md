# Stratus — runtime API weather station

Stratus is a self-contained miniature observatory demonstrating **HTTP JSON → C# DTO → gameplay**. Its architecture and graphics are generated from original sample code: an observatory, a wind turbine, an anemometer, solar panels, vegetation, animated clouds and precipitation. UI Toolkit displays current conditions, a 12-sample temperature graph and the actual DTO values driving the world.

## Play

Open **Tools → DataCraft → Samples and Quick Start → Install / open Stratus weather station**, or import this sample from Unity Package Manager and open `Scenes/WeatherStation.unity`. Press Play. For recording use a 1920×1080 Game resolution and set the Game view scale to Fit; an enlarged Editor preview can crop the view without changing the actual game output.

Startup uses **explicitly labelled synthetic demo data**. Choose Madrid, Tokyo or Reykjavík to explore sun, rain or snow. **Fetch live** makes one request for the selected city. A successful response changes the badge to **LIVE RESPONSE / MODELED WEATHER** and displays the provider's validity time. Weather-code/cloud/precipitation values change the miniature, wind speed drives its rotors, wind direction rotates the vane and temperature drives the animated readout and graph. Open-Meteo's current conditions are model data, not a local sensor reading.

Changing city cancels the pending request and switches to that city's demo fixture; it does not silently fetch another city. **Use demo data** cancels and restores the selected fixture. A failed refresh keeps the current data and clearly identifies the failure/offline state. Requests have a 12-second deadline, a 256 KiB body limit and a three-second minimum interval; there is no polling. Disabling/destroying the sample cancels pending work. Startup, offline use and all network results write no save files, authoring drafts, generated output or Build Settings.

## Follow the C# data

`Runtime/WeatherStationDemo.cs` calls the public runtime API:

```csharp
WeatherDto response = await DataCraftApi.GetAsync<WeatherDto>(url,
    new DataCraftApiOptions { TimeoutSeconds = 12, MaxResponseBytes = 256 * 1024 },
    destroyCancellationToken);
response.Validate();
float wind = response.current.wind_speed_10m;
```

`WeatherDto.cs` describes the provider's nested `current`, `hourly`, arrays and units dictionary. Json.NET `Required.Always` members prevent a malformed response from silently becoming zero-degree clear weather. Validation checks the measurements and matching forecast arrays before replacing the last valid state. The three offline fixtures go through **the same `DataCraftRawJson.Deserialize<WeatherDto>` reader** as the live response. They are examples, not cached/current provider data.

This workflow needs no Designer template or Project Data export. API deserialization is separate from `DataCraftJson.Deserialize<T>` (DataCraft save envelopes), read-only generated catalogs and Editor URL imports. Use the DTO values directly in your gameplay code; save selected progress separately if your game needs it.

## Dependencies and rendering

The package declares Unity's official `com.unity.nuget.newtonsoft-json` 3.2.2 and `com.unity.modules.unitywebrequest` dependencies. Stratus also uses UI Toolkit. The sample ships its own font, theme, persistent PanelSettings asset, prepared scene and a sample-only linker file retaining its DTOs. Keep the scene's PanelSettings reference: Unity uses the asset to include advanced-text/ICU resources in builds. The font's licence is in `Fonts`. It does not require Emberfall, Input System or Unity UI.

Materials select the current render pipeline's Lit shader or built-in Standard shader. Keep the scene's shader references when preparing a Player. Native rendering evidence records the tested pipeline; other pipeline/backend configurations need their own verification. Game-owned DTOs used through reflection on IL2CPP need suitable `[Preserve]`/`link.xml` coverage and, for generic collections on AOT, the required generic instantiations. Do not infer broad AOT/platform certification from the Windows Mono checks.

## Provider and attribution

Default provider: [Open-Meteo Forecast API](https://open-meteo.com/en/docs). Weather data attribution is displayed in the sample (**Open-Meteo / CC BY 4.0**). Its [free endpoint terms](https://open-meteo.com/en/terms) allow non-commercial use; a commercial game or promotional deployment needs an appropriate provider plan. No subscription/key is bundled. The startup fixtures are synthetic and work without that service. Adapt `apiBaseUrl`/request construction for your own authorized endpoint or backend; do not ship private server credentials in a client build.

Web builds need the endpoint to permit browser CORS. API availability, rate limits and provider data are external to DataCraft. There is no geolocation request: all three example cities use fixed public coordinates.

## Reusable API endpoint

The prepared scene now references `Runtime/OpenMeteoEndpoint.asset`. Select it in **DataCraft > APIs** to inspect the GET URL, `{latitude}` / `{longitude}` parameters, 12-second deadline and 256 KiB limit. Fetch live passes the selected city's coordinates to `apiEndpoint.SendAsync<WeatherDto>`; it does not concatenate raw user input into a URL. The legacy `apiBaseUrl` fallback is retained for existing scenes/tests without an assigned endpoint. Neither startup nor selecting a profile sends a request.
