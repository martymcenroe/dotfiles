# Startup & Services Configuration — Windows 11

Last updated: 2026-03-17

## Context

Alienware desktop, 32 GB RAM, NVMe SSD. Running 6-8 concurrent unleashed sessions.
C5/C6 neck injury — dual mice, Logitech G Hub REQUIRED for right-hand button swap.
Brio camera — Logi Tune REQUIRED for video calls.
Fast Startup permanently disabled (`powercfg -h off`) on 2026-03-17 — ensures clean shutdown clears WMI/process state.

## Startup Apps

### Enabled at boot (keep)

| App | Registry | Purpose | Notes |
|-----|----------|---------|-------|
| LGHUB | HKCU\Run | Mouse button swap | CRITICAL — right-hand mouse unusable without it |
| Logi Tune | HKLM\Run | Brio camera management | CRITICAL — 8 processes, 689 MB. Heavy but necessary for calls. |
| SecurityHealth | HKLM\Run | Windows Security tray | Lightweight |
| RtkAudUService | HKLM\Run | Realtek audio | Lightweight |
| Kensington KonnectT-TB | HKLM\Run | Trackball driver | Lightweight |
| Kensington KonnectT-DK | HKLM\Run | Dock driver | Lightweight |

### Disabled at boot (launch manually when needed)

| App | Registry | How disabled | Why |
|-----|----------|-------------|-----|
| Evernote | HKCU\Run | Task Manager → Startup | Used daily but doesn't need to start at boot. Open from Start menu. |
| Steam | HKCU\Run | Already disabled (StartupApproved byte=3) | Gaming. Launch before playing. |
| Adobe Acrobat Sync | HKCU\Run | Already disabled (StartupApproved byte=3) | PDF sync. Rarely needed. |
| Edge AutoLaunch | HKCU\Run | Already disabled (StartupApproved byte=3) | Not primary browser. |
| SteelSeriesGG | HKLM\Run | Admin required (see commands below) | Gaming peripherals. Launch before gaming. |
| GoogleUpdater | HKCU\Run | Task Manager → Startup | Google scheduled tasks handle updates anyway. |

### Delayed at boot (60-90 seconds after login via Task Scheduler)

| App | Original location | Delay | Why |
|-----|-------------------|-------|-----|
| OneDrive | HKCU\Run | 60s | 229 MB, heavy disk I/O — cloud sync can wait |
| GoogleDriveFS | HKCU\Run | 60s | Same — cloud sync doesn't need to race LGHUB |
| Teams | HKCU\Run | 90s | Not joining a call in the first 90s |

### Optional: Move LGHUB to HKLM (starts in first batch)

HKLM\Run fires before HKCU\Run. Moving LGHUB there puts it alongside Logi Tune in the first batch.

In an admin bash shell (right-click Start → Terminal (Admin)):

```bash
# Add to HKLM (starts with first batch)
powershell -Command 'New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "LGHUB" -Value "\"C:\Program Files\LGHUB\system_tray\lghub_system_tray.exe\" --minimized" -PropertyType String -Force'

# Remove from HKCU (no longer in second batch)
powershell -Command 'Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "LGHUB"'
```

### Admin commands for other changes

**Disable SteelSeriesGG from startup** (admin bash):
```bash
powershell -Command 'Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SteelSeriesGG"'
```

**Create delayed startup tasks** (admin bash — run once each):
```bash
# OneDrive — delay 60s
powershell -Command 'Register-ScheduledTask -TaskName "OneDrive-Delayed" -Action (New-ScheduledTaskAction -Execute "C:\Users\mcwiz\AppData\Local\Microsoft\OneDrive\OneDrive.exe" -Argument "/background") -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 0)) -Description "OneDrive delayed start (60s after login)"; $t = Get-ScheduledTask "OneDrive-Delayed"; $t.Triggers[0].Delay = "PT60S"; Set-ScheduledTask -InputObject $t'

# GoogleDriveFS — delay 60s
powershell -Command 'Register-ScheduledTask -TaskName "GoogleDriveFS-Delayed" -Action (New-ScheduledTaskAction -Execute "C:\Program Files\Google\Drive File Stream\122.0.1.0\GoogleDriveFS.exe" -Argument "--startup_mode") -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 0)) -Description "Google Drive delayed start (60s after login)"; $t = Get-ScheduledTask "GoogleDriveFS-Delayed"; $t.Triggers[0].Delay = "PT60S"; Set-ScheduledTask -InputObject $t'

# Teams — delay 90s
powershell -Command 'Register-ScheduledTask -TaskName "Teams-Delayed" -Action (New-ScheduledTaskAction -Execute "C:\Users\mcwiz\AppData\Local\Microsoft\WindowsApps\MSTeams_8wekyb3d8bbwe\ms-teams.exe" -Argument "msteams:system-initiated") -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 0)) -Description "Teams delayed start (90s after login)"; $t = Get-ScheduledTask "Teams-Delayed"; $t.Triggers[0].Delay = "PT90S"; Set-ScheduledTask -InputObject $t'
```

After creating delayed tasks, disable the original startup entries in **Task Manager → Startup apps** (right-click → Disable) for OneDrive, GoogleDriveFS, and Teams.

## Services

### Set to Manual (2026-03-16, first pass)

| Service | DisplayName | Why |
|---------|-------------|-----|
| AWCCService | Alienware Command Center | Memory leak (933 MB observed). Open manually before gaming/ML. |
| Alienware Digital Delivery | Alienware Digital Delivery Services | Dell bloatware |
| Alienware SupportAssist Remediation | Alienware SupportAssist Remediation | Dell bloatware |
| DellClientManagementService | Alienware Client Management | Dell bloatware |
| DellTechHub | Dell TechHub | Dell bloatware |
| XboxGipSvc | Xbox Accessory Management | Not using Xbox accessories |
| XboxNetApiSvc | Xbox Live Networking | Not using Xbox Live |
| WerSvc | Windows Error Reporting | Telemetry |
| wercplsupport | Problem Reports Control Panel | Telemetry UI |
| PrintNotify | Printer Extensions and Notifications | Not actively printing |
| PrintDeviceConfigurationService | Print Device Configuration | Not actively printing |
| PrintScanBrokerService | PrintScanBrokerService | Not actively printing |

### Set to Manual (2026-03-17, second pass — recommended)

| Service | DisplayName | Why safe |
|---------|-------------|----------|
| DiagTrack | Connected User Experiences and Telemetry | Microsoft telemetry. Zero user impact. |
| dptftcs | Intel Dynamic Tuning Telemetry | Intel telemetry. Zero user impact. |
| InventorySvc | Inventory and Compatibility Appraisal | App compat scanning. Starts on demand. |
| whesvc | Windows Health and Optimized Experiences | Telemetry. |
| PcaSvc | Program Compatibility Assistant | Old app warnings. Rarely useful. |
| iphlpsvc | IP Helper | IPv6 transition. Not needed on home network. |
| TrkWks | Distributed Link Tracking Client | NTFS link tracking across volumes. |
| WSAIFabricSvc | WSAIFabricSvc | Windows AI Fabric. Not in use. |
| StiSvc | Windows Image Acquisition (WIA) | Scanner support. Starts on demand when scanning. |

### Keep on Automatic

| Service | Why |
|---------|-----|
| LGHUBUpdaterService | Keeps G Hub current — mouse button swap depends on it |
| OptionsPlusUpdaterService (Logi Options+) | Logitech peripheral support |
| LogiTuneUpdaterService | Keeps Tune current — Brio camera depends on it |
| LogiSyncStub | Logitech multi-device sync |
| logi_lamparray_service | Logitech LED control |
| Killer Network Service | Network driver for Killer NIC (Alienware) |
| NVDisplay.ContainerLocalSystem | NVIDIA GPU display |
| ClickToRunSvc | Microsoft Office updates |
| Winmgmt | WMI — core dependency for unleashed companion cleanup |
| All core Windows services | RPC, DCOM, DNS, Firewall, Audio, Event Log, etc. |

### User's call

| Service | Tradeoff |
|---------|----------|
| SysMain (Superfetch) | On NVMe, minimal benefit. Manual saves ~100 MB RAM. |
| Spooler (Print Spooler) | If rarely printing, Manual is fine. Starts on demand when you print. |

## WMI Recovery

See `wmi-hung-system-slow.md` in this directory for the full runbook.
Quick check: `powershell -NoProfile -Command '(Measure-Command { Get-Process | Out-Null }).TotalSeconds'`
If > 5 seconds, WMI is sick.
