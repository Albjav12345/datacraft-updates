# Helio — API response to playable sunlight

Helio connects a real sunrise/sunset request to an original 3D coastal miniature. A lighthouse, sandstone island, copper gallery, sea contours and a solar arc respond to a scrubbed local-time timeline. The provider supplies event times; the sun path, colours and intensity are **illustrative art direction**, not a physical astronomy simulation or measured current light.

## Play it

Open **Tools > DataCraft > Samples and Quick Start > Install / open Helio sunlight demo**. After import, open `Scenes/Sunlight.unity` and press Play. Unity Package Manager can also import this sample. UI Toolkit is required; Emberfall and Stratus are independent samples. Installation never replaces an existing sample folder, modifies project templates, saves a checkpoint or adds Build Settings entries.

1. Startup is labelled **DEMO / SYNTHETIC DATA**, using a made-up Madrid solar day dated 21 June 2026. No request runs on startup.
2. Enter decimal latitude and longitude (dot as decimal separator). The prepared defaults are Madrid, `40.4168`, `-3.7038`. **Fetch live** sends one request to the saved `Runtime/SunriseSunsetEndpoint.asset`.
3. After success the source label changes to **LIVE RESPONSE / PROVIDER DATA**. The date, returned coordinates and location timezone identify the result. These are the requested day's events, not a current weather reading. Device-local time is never substituted for the provider's timestamp offset.
4. Choose **Sunrise**, **Solar noon** or **Sunset** to move to an actual returned event. Drag the timeline to preview the rest of that day. Light, sky, water, stars and the lantern change smoothly. An absent event is shown as `—` and its button is disabled; polar days/nights are labelled.
5. **Cancel** aborts the pending request. **Demo data** cancels it and restores the labelled synthetic fixture. Errors keep the previous result and its source label, with a separate message suggesting the next action. Coordinates are locked during a request; requests have a three-second minimum interval, a 12-second deadline and a 256 KiB response limit. There is no polling, retry loop or automatic save.

**Open Helio endpoint in APIs** in Samples opens the same saved configuration in DataCraft. Fill `latitude` and `longitude`, then choose **Test request** to inspect the JSON. The runtime scene is already wired; **Import into template** is not needed. That is an optional Editor content-import workflow for lists such as catalogs.

## Follow the C#

The scene's **SunriseGameplay** component is the reusable caller. **SunlightDemo** contains the presentation and original procedural geometry. To adapt it to your own scene, add `SunriseGameplay`, assign a saved endpoint using `GET`, an empty response path and named `{latitude}` / `{longitude}` parameters. Then invoke **Fetch** from a UI button, the component context menu or code:

```csharp
// Reference the scene's SunriseGameplay component.
sunData.latitude = 40.4168;
sunData.longitude = -3.7038;
await sunData.FetchAsync();
if (sunData.IsLive && sunData.Day?.Sunset is System.DateTimeOffset sunset)
    sunsetLabel.text = sunset.ToString("HH:mm");
```

Subscribe to `Changed` for updates, use `IsLoading` / `Status` for request UI and `Day` for immutable validated gameplay values. `Latest` retains the complete typed subset of the provider response. `CancelRequest` and disabling/destroying the caller cancel pending work. Overlapping requests are ignored; late/cancelled results never replace the current state. Always unsubscribe your listeners when disabling your own component.

The actual request is:

```csharp
SunResponse response = await endpoint.SendAsync<SunResponse>(parameters,
    cancellationToken: token);
SunDay day = new SunDay(response); // validate before publishing or applying it
```

The shipped `SunResponse` is a **reviewed subset of the provider v2 contract**: fractional coordinates, independently nullable solar events and nullable day length. It is not an untouched inference from one successful JSON sample. When generating your own client in APIs, review those types/nullability before shipping. The sample does not modify any previously generated client, including `SunsetRise`; it demonstrates the validation and game code you own after generation. Do not assume a field observed as an integer or non-null in one response always stays that way.

`SunDay.Daylight(hour)` is an illustrative curve between returned event times. Polar states have explicit values. A normal transition day missing either sunrise or sunset retains valid timestamps but uses neutral illustrative light, instead of inventing an event. This is not an orbital/solar-position solver.

## Contract, provider and builds

[Sunrise-Sunset.org v2 documentation](https://sunrise-sunset.org/api) defines the endpoint, independently nullable events and polar statuses. No API key is required. The UI includes the required visible **Sun data by Sunrise-Sunset.org** credit and link. Reasonable usage limits, service availability and HTTP 429 remain provider controlled. There is no geolocation permission or private credential involved. All coordinates are supplied explicitly.

The sample has its own font/licence, theme, persistent PanelSettings, prepared scene and linker descriptor. Its English UI explicitly uses the standard Unity text generator to keep rendering independent of project-wide advanced text settings. Keep their scene references so text and shaders are included in builds. Materials support the built-in pipeline and URP shader selection; other render pipelines/backends require their own verification. Web deployment depends on provider CORS. The linker descriptor retains the sample's DTOs; it is not certification of IL2CPP or other platforms.

Development-source tests (omitted from the normal commercial package) cover the reviewed contract and prepared scene; Play Mode tests use a loopback fixture to exercise actual `SunriseGameplay` requests, parameter snapshots, HTTP/JSON failures, throttling and cancellation. No live provider requests are made by the tests.
