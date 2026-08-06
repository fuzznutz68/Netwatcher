# NetWatch Desktop

Domain Intelligence & Network Info for Windows 11

## Features

- **🌐 Domain Intel** — Discover subdomains, IPs, CDN, shared hosts, and geo-IP data for any domain
- **✅ Domain Checker** — Verify connectivity to well-known service domains (Google, Microsoft, Cloudflare, Social, Streaming, Gaming, AI, Finance)
- **📡 My Info** — Your public IP, ISP, geolocation, timezone, and coordinates with Google Maps link

## Building

### Requirements
- Windows 11
- .NET 8 SDK (or Visual Studio 2022 Community — free)
- No third-party libraries — pure .NET WPF

### Build with Visual Studio
1. Open `NetWatchDesktop.sln` in Visual Studio 2022
2. Press `Ctrl+B` to build
3. Press `F5` to run

### Build from command line
```
dotnet build -c Release
dotnet run -c Release
```

The compiled executable will be at:
```
bin\Release\net8.0-windows\NetWatch.exe
```

## Architecture

- Same terminal aesthetic as the Android app (deep black `#0A0E17`, electric cyan `#00E5FF`)
- Uses the same public backend API endpoints as the mobile app
- Domain Checker categories match the Android version exactly
- Geo-IP lookups via ipinfo.io (same as mobile)
- Consolas monospace font throughout

## Backend APIs

All network intelligence is powered by the same public backend functions:
- `domainIntel` — Subdomain discovery, IP resolution, CDN detection, shared-host analysis
- `ipinfo.io` — Geo-IP enrichment
- `api.ipify.org` — Public IP detection

No traffic monitoring features — this is a lightweight companion to the Android app.
