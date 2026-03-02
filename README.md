# Thunder Startup Services

systemd service units for managed activation of [WPEFramework (Thunder)](https://github.com/rdkcentral/Thunder) plugins on RDK-based devices.

## Overview

This repository provides a collection of systemd `.service` files that control the startup order and lifecycle of Thunder (WPEFramework) plugins on RDK devices such as set-top boxes and streaming sticks. Each service file wraps a call to `PluginActivator`, ensuring a plugin is only activated after WPEFramework itself is fully running and any required system daemons are available.

## How It Works

```
wpeframework.service starts
        │
        └─► creates /tmp/wpeframeworkstarted
                    │
                    ▼
       wpeframework-services.path detects the file
                    │
                    ▼
       wpeframework-services.target activates
                    │
                    ▼
       Individual plugin services start (often gated by conditions such as ConditionPathExists=/tmp/wpeframeworkstarted)
                    │
                    ▼
       /usr/bin/PluginActivator <plugin-callsign>
```

### Key Components

| File | Role |
|---|---|
| `wpeframework-services.path` | Inotify watcher on `/tmp/wpeframeworkstarted`; triggers the target when the file appears |
| `wpeframework-services.target` | Ordering anchor that plugin services pull from; its concrete dependency list (`Requires=`/`Wants=`) is populated by the BitBake build system at image build time |
| Individual `*.service` files | One-shot services that call `PluginActivator` for a specific plugin callsign |

The set of plugin `*.service` units that are tied into `wpeframework-services.target` is not hardcoded in this repository. Instead, the BitBake `.bb` recipes used to build the image generate and attach the appropriate `Requires=`/`Wants=` dependencies to `wpeframework-services.target` at build time.
Each plugin service is `Type=oneshot` with `RemainAfterExit=yes`, so systemd tracks it as active after the activator exits successfully.

## Services

### Core / Infrastructure

| Service | Plugin Callsign |
|---|---|
| `wpeframework-system.service` | `org.rdk.System` |
| `wpeframework-ocdm.service` | `OCDM` |
| `wpeframework-monitor.service` | `Monitor` |
| `wpeframework-migration.service` | `org.rdk.Migration` |
| `wpeframework-powermanager.service` | `org.rdk.PowerManager` |
| `wpeframework-systemmode.service` | `org.rdk.SystemMode` |
| `wpeframework-deviceinfo.service` | `DeviceInfo` |
| `wpeframework-userpreferences.service` | `org.rdk.UserPreferences` |

### Display / AV

| Service | Plugin Callsign |
|---|---|
| `wpeframework-displayinfo.service` | `DisplayInfo` |
| `wpeframework-displaysettings.service` | `org.rdk.DisplaySettings` |
| `wpeframework-avinput.service` | `org.rdk.AVInput` |
| `wpeframework-avoutput.service` | `org.rdk.AVOutput` |
| `wpeframework-hdcpprofile.service` | `org.rdk.HdcpProfile` |
| `wpeframework-hdmicecsink.service` | `org.rdk.HdmiCecSink` |
| `wpeframework-hdmicecsource.service` | `org.rdk.HdmiCecSource` |
| `wpeframework-playerinfo.service` | `PlayerInfo` |
| `wpeframework-rdkshell.service` | `org.rdk.RDKShell` |
| `wpeframework-rdkwindowmanager.service` | `org.rdk.RDKWindowManager` |
| `wpeframework-frontpanel.service` | `org.rdk.FrontPanel` |

### Networking

| Service | Plugin Callsign |
|---|---|
| `wpeframework-network.service` | `org.rdk.Network` |
| `wpeframework-networkmanager.service` | `org.rdk.NetworkManager` |
| `wpeframework-wifi.service` | `org.rdk.Wifi` |
| `wpeframework-locationsync.service` | `LocationSync` |

### Storage

| Service | Plugin Callsign |
|---|---|
| `wpeframework-persistentstore.service` | `org.rdk.PersistentStore` |
| `wpeframework-sharedstorage.service` | `org.rdk.SharedStorage` |
| `wpeframework-cloudstore.service` | `org.rdk.CloudStore` |
| `wpeframework-storagemanager.service` | `org.rdk.StorageManager` |

### App Lifecycle (AI 2.0)

These services are only enabled when `/opt/ai2managers` exists on the device.

| Service | Plugin Callsign |
|---|---|
| `wpeframework-appmanager.service` | `org.rdk.AppManager` |
| `wpeframework-lifecyclemanager.service` | `org.rdk.LifecycleManager` |
| `wpeframework-runtimemanager.service` | `org.rdk.RuntimeManager` |
| `wpeframework-packagemanager.service` | `org.rdk.PackageManagerRDKEMS` |
| `wpeframework-downloadmanager.service` | `org.rdk.DownloadManager` |
| `wpeframework-preinstallmanager.service` | `org.rdk.PreinstallManager` |

| `wpeframework-lisa.service` | `LISA` |
| `wpeframework-ocicontainer.service` | `org.rdk.OCIContainer` |

### App Gateway

These services are only enabled when `/opt/appgatewayenabled` exists on the device.

| Service | Plugin Callsign |
|---|---|
| `wpeframework-appgateway.service` | `org.rdk.AppGateway` |
| `wpeframework-appgatewaycommon.service` | `org.rdk.AppGatewayCommon` |
| `wpeframework-appnotifications.service` | `org.rdk.AppNotifications` |

### Connectivity / Peripheral

| Service | Plugin Callsign |
|---|---|
| `wpeframework-bluetooth.service` | `org.rdk.Bluetooth` |
| `wpeframework-remotecontrol.service` | `org.rdk.RemoteControl` |
| `wpeframework-usbdevice.service` | `org.rdk.UsbDevice` |
| `wpeframework-usbmassstorage.service` | `org.rdk.UsbMassStorage` |
| `wpeframework-xcast.service` | `org.rdk.Xcast` |

### Security / DRM

| Service | Plugin Callsign |
|---|---|
| `wpeframework-cryptography.service` | `org.rdk.Cryptography` |

### Voice / Accessibility

| Service | Plugin Callsign |
|---|---|
| `wpeframework-texttospeech.service` | `org.rdk.TextToSpeech` |
| `wpeframework-voicecontrol.service` | `org.rdk.VoiceControl` |
| `wpeframework-systemaudioplayer.service` | `org.rdk.SystemAudioPlayer` |
| `wpeframework-messenger.service` | `Messenger` |

### Telemetry / Analytics

| Service | Plugin Callsign |
|---|---|
| `wpeframework-analytics.service` | `org.rdk.Analytics` |
| `wpeframework-telemetry.service` | `org.rdk.Telemetry` |
| `wpeframework-telemetrymetrics.service` | `org.rdk.TelemetryMetrics` |

### Maintenance

| Service | Plugin Callsign |
|---|---|
| `wpeframework-maintenancemanager.service` | `org.rdk.MaintenanceManager` |
| `wpeframework-firmwareupdate.service` | `org.rdk.FirmwareUpdate` |
| `wpeframework-usersettings.service` | `org.rdk.UserSettings` |

### Webkit Browser

| Service | Plugin Callsign |
|---|---|
| `wpeframework-motiondetection.service` | `org.rdk.MotionDetection` |

## Repository Structure

```
thunder-startup-services/
├── systemd/
│   └── system/
│       ├── wpeframework-services.path      # Path watcher (entry point)
│       ├── wpeframework-services.target    # Ordering target
│       └── wpeframework-*.service          # Per-plugin activation services
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE                                 # Apache 2.0
└── NOTICE
```

## Conditional Feature Flags

Several services gate activation on the presence of a flag file:

| Flag path | Effect |
|---|---|
| `/tmp/wpeframeworkstarted` | Commonly required by Thunder plugin services that should start only after WPEFramework is running (set by WPEFramework on startup; some units may omit this condition) |
| `/opt/ai2managers` | Enables AI 2.0 App Lifecycle services; disables legacy equivalents (RDKShell, LISA) |
| `/opt/appgatewayenabled` | Enables the AppGateway plugin stack |

## Contributing

Contributions are made via GitHub pull requests. You must sign the RDK Contributor License Agreement (CLA) before your code can be accepted. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

Copyright 2024 Comcast Cable Communications Management, LLC.
Licensed under the [Apache License, Version 2.0](LICENSE).
