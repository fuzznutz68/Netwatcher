# NetWatch APK — Build Instructions

## Prerequisites
- **Android Studio** (latest stable, e.g. Hedgehog 2023.1.1+)
- **JDK 17** (bundled with Android Studio)
- Android SDK API 34 installed

---

## Step 1 — Open the project
1. Open Android Studio
2. File → Open → Select the `NetWatchAPK/` folder
3. Wait for Gradle sync to complete (~2 min on first run)

---

## Step 2 — Build the APK
```
Build → Build Bundle(s) / APK(s) → Build APK(s)
```
Or via command line:
```bash
cd NetWatchAPK
./gradlew assembleDebug
```
Output: `app/build/outputs/apk/debug/app-debug.apk`

---

## Step 3 — Install on your Android device
**Via USB:**
```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

**Via file transfer:**
1. Copy the `.apk` to your Android device
2. On the device: Settings → Security → Allow installation from unknown sources
3. Open the APK file to install

---

## Permissions the app will request
| Permission | Why |
|---|---|
| `INTERNET` | DNS lookups and domain scanning |
| `ACCESS_NETWORK_STATE` | Check connectivity |
| `BIND_VPN_SERVICE` | VPN-based traffic capture (no root!) |
| `FOREGROUND_SERVICE` | Keep monitoring alive in background |
| `POST_NOTIFICATIONS` | Show VPN active notification |

---

## Tab 1 — Domain Intelligence
- Enter any domain (with or without `https://`)
- Tap **Scan**
- Results show: IPv4/IPv6, subdomains, MX, NS, TXT records, reverse IP

## Tab 2 — Traffic Monitor
- Enter the domain you want to monitor
- Tap **Start Monitoring**
- Android will ask you to approve a VPN connection — tap **OK**
- All traffic to/from that domain on **this device only** is logged live
- Each log entry shows: direction (⬆️/⬇️), protocol, host, IP:port, data size, time
- Tap **Stop** to end monitoring

---

## How the VPN works (no root required)
Android's `VpnService` API lets any app create a local TUN (tunnel) interface
that captures all traffic from the device. NetWatch uses this to:
1. Intercept outgoing IP packets
2. Parse TCP/UDP headers to extract destination IP + port
3. Filter for packets matching your monitored domain
4. Display them in real-time in the Traffic Monitor tab
5. Forward all packets transparently (nothing is blocked)

The VPN is **local-only** — no traffic leaves through an external server.

---

## Minimum requirements
- Android 11 (API 30) or higher
- No root required
- ~3 MB install size
