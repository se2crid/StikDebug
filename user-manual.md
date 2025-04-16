## Pairing Instructions

### Downloads
Downloads for Jitterbug Pair can be found [here.](https://github.com/osy/Jitterbug/releases/tag/v1.3.1)

---

### For Windows

1. **Extract** `Jitterbugpair-win64.zip`.
2. **Set a passcode** for your device if you haven't already. Ensure the device is connected via cable and unlocked.
3. Open your device to the homescreen.
4. In File Explorer, locate `jitterbugpair.exe` and run it by double-clicking or right-clicking and selecting "Open".
5. JitterbugPair will generate a **pairing file** in the same folder. This file will have the extension `.mobiledevicepairing`.
6. **Transfer the pairing file** to your iOS device using Google Drive, email, or any other method.

---

### For macOS

1. **Extract** `Jitterbugpair-macos.zip`.
2. **Set a passcode** for your device if you haven't already. Ensure the device is connected via cable and unlocked.
3. Open your device to the homescreen.
4. Execute `JitterBugPair` by double-clicking or right-clicking and selecting "Open".
5. JitterBugPair will generate a **pairing file** with the extension `.mobiledevicepairing`.
6. **Transfer the pairing file** to your iOS device using Google Drive, email, or any other method.

---

### On your iOS device

1. In the **Files app**, long-press your zipped pairing file and select **Uncompress**.
2. Launch the **StikJIT or StikDebug** app.
    - If the app doesn’t appear, restart your device.
3. When prompted, import the **unzipped pairing file**.
4. StikJIT or StikDebug will now be **paired** with your computer.

---

### Notes

- If you **update your iDevice**, the pairing file will become **invalid**, and you’ll need to repeat the pairing process.
- To prompt SideStore to ask for the pairing file again, go to **SideStore > Settings** and tap **Reset Pairing File**.

# How to Install StikJIT

This document outlines the installation process for StikJIT, both with and without SideStore, along with usage instructions, troubleshooting tips, and frequently asked questions.

## Installation with SideStore or AltStore Classic

1. **Install SideStore of AltStore:**  
   Visit the [SideStore](https://sidestore.io/#get-started) or [AltStore](https://altstore.io) website and follow the provided installation instructions.

2. **Install StosVPN:**  
   It is recommended to install [StosVPN](https://apps.apple.com/us/app/stosvpn/id6744003051).
3. **Obtain the StikJIT IPA:**  
   Download the StikJIT IPA from [StikJIT](https://github.com/0-Blu/StikJIT/releases/latest).

4. **Install via SideStore:**  
   Use SideStore or AltStore to install the downloaded IPA. Once the installation is complete, the process is finished.

## Installation with AltStore PAL (EU Only)

1. **Install StikDebug:**  
   Download StikDebug from AltStore PAL and follow the standard installation procedures.

2. **Install AltStore Classic:**  
   Next, install AltStore Classic via AltStore PAL. AltStore Classic will automatically detect that StikDebug is installed.

3. **Enable JIT:**  
   In AltStore Classic, press and hold the desired app, then select the "Enable JIT" option to activate the feature.

## Installation without SideStore or AltStore

If you prefer not to use SideStore, alternative methods such as Sideloadly or AltStore are available.

1. **Download the StikJIT IPA:**  
   Obtain the IPA from [StikJIT](https://github.com/0-Blu/StikJIT/releases/latest).

2. **Download StosVPN via TestFlight:**  
   Get the latest version of [StosVPN]() from the AppStore.

3. **Create a Pairing File:**  
   Follow the instructions in the Pairing Guide section to generate a pairing file. Afterward, compress (zip) the pairing file.

4. **Transfer the Pairing File:**  
   Share the zipped pairing file with your device. It is recommended to email the file to yourself or upload it to a cloud service such as Google Drive or Proton Drive.

## How to Use StikJIT

1. **Enable StosVPN:**  
   Start by activating StosVPN.

2. **Upload the Pairing File:**  
   Open the StikJIT application and upload the pairing file obtained via Jitterbugpair.

3. **Activate JIT:**  
   Click the “Enable JIT” button and select an app from the list to activate the JIT functionality.

## Common Issues and Solutions

### Pairing File Issue -9

- **Issue:** This error may occur if the pairing file has been modified or if a new pairing file was created.
- **Solution:**  
  Generate a new pairing file using JitterBugPair and retry the process.

### Keeping the IPA Up-to-Date

- **Issue:** StikJIT is frequently updated with bug fixes.
- **Recommendation:**  
  Reinstall the latest IPA every 1–2 days to ensure optimal performance.  

## Frequently Asked Questions

- **Does this work with LiveContainer?**  
  Yes, it functions in the same manner.

- **Do I need to be connected to Wi-Fi?**  
The first launch requires Wi-Fi to mount the ddi. After this you can use Wi-Fi or Airplane mode.

- **Can this be used with a certificate?**  
  Yes, it has to be used with a developer certificate. Distribution and enterprise certificates will **NOT** work.

- **Is this open source?**  
  Yes, the source code is available on [GitHub](https://github.com/0-Blu/StikJIT).

- **What iOS versions are supported?**  
  Supported versions range from iOS 17.4 to iOS 18.5 Developer Beta 2 (latest version).

- **Will devices with versions below iOS 17.4 work?**  
  No, an update to iOS 17.4 or higher is required.

- **Does iOS 18.4 beta 1 work?**  
  No, Apple broke JIT in this version. You should update. 

- **Will StikDebug be available on the normal App Store?**  
  Maybe, it is unclear if Apple will allow it.

- **Is WireGuard still an option, or is StosVPN required?**  
StosVPN is required for StikJIT to work properly. It is not needed for StikDebug because the vpn is built in.

# Idevice Error Codes 

## Main Library Errors
- `Socket` (-1)
- `Ssl` (-2)
- `SslSetup` (-3)
- `Plist` (-4)
- `Utf8` (-5)
- `UnexpectedResponse` (-6)
- `GetProhibited` (-7)
- `SessionInactive` (-8)
- `InvalidHostID` (-9) (New Pairing File)
- `NoEstablishedConnection` (-10)
- `HeartbeatSleepyTime` (-11)
- `HeartbeatTimeout` (-12)
- `NotFound` (-13)
- `CdtunnelPacketTooShort` (-14)
- `CdtunnelPacketInvalidMagic` (-15)
- `PacketSizeMismatch` (-16)
- `Json` (-17)
- `DeviceNotFound` (-18)
- `DeviceLocked` (-19)
- `UsbConnectionRefused` (-20)
- `UsbBadCommand` (-21)
- `UsbBadDevice` (-22)
- `UsbBadVersion` (-23)
- `BadBuildManifest` (-24)
- `ImageNotMounted` (-25)
- `Reqwest` (-26)
- `InternalError` (-27)
- `Xpc` (-28)
- `NsKeyedArchiveError` (-29)
- `UnknownAuxValueType` (-30)
- `UnknownChannel` (-31)
- `AddrParseError` (-32)
- `DisableMemoryLimitFailed` (-33)
- `NotEnoughBytes` (-34)
- `Utf8Error` (-35)
- `InvalidArgument` (-36)
- `UnknownErrorType` (-37)

## FFI-Specific Bindings
- `AdapterIOFailed` (-996)
- `ServiceNotFound` (-997)
- `BufferTooSmall` (-998)
- `InvalidString` (-999)
- `InvalidArg` (-1000)

# Mounting error codes
1 - Reading the DDI files failed, they probably failed to download
2 - Invalid target IP address (shouldn't happen, it's hardcoded)
3 - Failed to read/parse the pairing file
4 - Failed to create the TCP provider for the device (shouldn't happen, it's hardcoded)
5 - Failed to read/parse the pairing file
6 - Failed to connect to lockdownd (are you on cellular?)
7 - Failed to start SSL session (bad pairing file?)
8 - Failed to get the unique chip ID (send idevice logs to jkcoxson)
9 - Failed to connect to image mounter (are you on 17.0-.4? send idevice logs to jkcoxson)
10 - Mount failed (send idevice logs to jkcoxson)
