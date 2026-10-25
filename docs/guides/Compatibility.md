# Compatibility and tested boundaries

[Documentation home](index.md) · [Installation](../INSTALLATION.md) · [Web persistence](WebPersistence.md)

## Requirements

Minimum declared Editor: **Unity 6.0 LTS 6000.0.85f1**. Core UPM installation resolves official Newtonsoft JSON **3.2.2**, UnityWebRequest and JSON Serialization. Neither NUnit nor optional sample packages are needed for core use.

| Optional example | Additional requirements |
| --- | --- |
| Emberfall | Universal RP, Unity UI (uGUI), Input System |
| Stratus and Helio | UI Toolkit; no Emberfall URP/uGUI/Input System requirement |

Minimum package metadata is not proof that every intervening patch, future Editor, renderer or platform is individually tested.

## Current 1.2.0 evidence

On **Windows Unity 6000.5.5f1**, the 1.2.0 core Editor suite passed **937/937** with zero failures/skips. Additional checks covered retail provider separation, signed metadata, official account/download access, exact authorized archive bytes and signed UPM upgrade/restoration across reload. The authorized live download was the already available 1.1.1 ZIP; the upgrade/restoration used a private future-version fixture. These are distinct checks, not a claim that an unannounced future update was downloaded from a public store.

The Unity r2 submission follow-up also verified the actual line-ending rule, two Play/Edit cycles with domain/scene reload disabled, and a minimal consumer without optional demo packages. The lifecycle check is scoped evidence, not certification of every in-flight request or Fast Enter Play configuration.

## Preserved earlier evidence

| Source/review | Configuration | Observed scope |
| --- | --- | --- |
| 1.1.1 | Windows 6000.0.85f1, 6000.3.27f1, 6000.5.5f1 | 846/846 core Editor tests per version |
| 1.1.1 LTS review | Windows 6000.0.85f1 and 6000.3.27f1 | Minimal consumer/examples, Mono Player with High stripping and cold-save restart |
| Earlier 2026-10-22 runtime review | Recorded Windows Mono/IL2CPP, physical Android ARM64 and Web configurations | 48/48 application checks per executed configuration |
| Earlier platform review | Linux/macOS builds; iOS device/simulator exports | Build/export only; native execution unverified |

The 1.2.0 update client has not been freshly run on the earlier LTS Editors or native macOS/Linux. Runtime bytes/formats remained unchanged, but older evidence does not become a fresh full-release test by inheritance.

## Renderer and sample boundaries

All three demos compiled together on Unity 6000.0.85f1 with URP 17.0.4, uGUI 2.0.0 and Input System 1.19.0. Stratus/Helio passed on 6000.3.27f1 without those Emberfall packages. In the tested 6000.3.27f1 installation, bundled URP 17.3.0 lacked converter-script metadata and failed independently of DataCraft; Emberfall is not certified with that combination. This does not certify HDRP or every pipeline/backend.

## Shipping checks that belong to your project

Preserve reflected DTO constructors/members and required generic instantiations for IL2CPP/AOT/stripping. Include the intended catalog, endpoint, shader, font and PanelSettings references. Build/test your real scene and backend rather than relying on Editor compilation alone.

Web saves require the selected template's persistent-data synchronization and same-origin/path reload testing. External APIs also require browser CORS. Device/app storage, quotas, credentials and provider terms remain environment-specific.

Save envelopes, authoring drafts and generated catalogs are separate formats. Your game owns player DTO upgrades and security/cloud policies. See [Local saves](SavesAndFiles.md), [HTTP JSON](HttpApi.md) and [Data/backups](DataAndBackups.md).
