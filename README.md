# Pomodoro

A simple macOS Pomodoro timer and a demo project showing how to set up any Mac app with [Sparkle](https://sparkle-project.org) auto-updates and [Amore](https://amore.computer) licensing.

[Download Pomodoro](https://api.amore.computer/v1/apps/computer.amore.Pomodoro/download)

**Demo license key:** `6E847-B1F9A-73BA7-A91F0-61A71-90113-7E033-073BE`

## What This Demonstrates

- **Over-the-air updates** via Sparkle + Amore, so users get update prompts automatically
- **License key validation** via the AmoreLicensing SDK
- **One-command releases** with `amore release` to build, sign, notarize, and publish

> Everything shown here via the CLI can also be done through the [Amore app](https://amore.computer/download) GUI.

## Setup Guide

### 1. Sparkle (Auto-Updates)

Add Sparkle as an SPM dependency, then initialize the updater in your App struct:

```swift
import Sparkle

private let updaterController = SPUStandardUpdaterController(
    startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil
)
```

Add `SUFeedURL`, `SUPublicEDKey`, and `SUEnableInstallerLauncherService` to your Info.plist. If your app is sandboxed, you also need mach-lookup exceptions for Sparkle's XPC services in your entitlements:

```xml
<key>com.apple.security.temporary-exception.mach-lookup.global-name</key>
<array>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)-spks</string>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)-spki</string>
</array>
```

Run `amore setup YourApp.app` to register the app and generate Sparkle signing keys.

### 2. Licensing

Add [AmoreKit](https://github.com/AmoreComputer/AmoreKit) as an SPM dependency. Initialize with your licensing public key:

```swift
import AmoreLicensing

let licensing = try AmoreLicensing(publicKey: "your-license-public-key")
```

The `licensing.status` property is `@Observable`. Switch on it to gate your UI:

```swift
switch licensing.status {
case .valid, .gracePeriod:
    TimerView()
default:
    LicenseView(licensing: licensing)
}
```

Create a product with the CLI:

```sh
amore products create -b com.example.App --name "My App" --device-limit 3
```

### 3. Releasing

```sh
amore release --scheme YourApp --release-notes "What's new"
```

This archives, code signs, creates a DMG, notarizes with Apple, signs for Sparkle, and uploads, all in one command.

## Requirements

- macOS 14.0+
- [Amore](https://amore.computer/download) for the CLI