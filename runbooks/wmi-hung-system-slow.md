# Runbook: WMI Hung / System Slow

**Symptoms:** Session takes 10+ minutes to start. File Explorer or apps won't launch. PowerShell commands hang. `tasklist` and `wmic` time out.

**Root cause (2026-03-16):** AWCC.Service (Alienware Command Center) leaked to 933 MB and hung WMI.

## Step 1: Confirm WMI is the problem

In your bash window (doesn't need admin):

```bash
powershell -NoProfile -Command '(Measure-Command { Get-Process | Out-Null }).TotalSeconds'
```

If this takes more than 5 seconds, WMI is sick.

## Step 2: Check AWCC memory usage

```bash
powershell -NoProfile -Command 'Get-Process AWCC* -EA 0 | Select-Object ProcessName,Id,@{N="MB";E={[math]::Round($_.WorkingSet64/1MB)}} | Format-Table -Auto'
```

If AWCC.Service is above 200 MB, it's leaking.

## Step 3: Restart WMI

Open admin shell: **Right-click Start button → Terminal (Admin)**

Whatever shell opens (bash or PowerShell), run:

```bash
powershell -Command "net stop winmgmt /y; net start winmgmt"
```

This works from bash or PowerShell — the `powershell -Command` wrapper handles it either way.

If WMI won't stop after 2-3 minutes: **reboot.** Once WMI is hung badly enough, nothing short of reboot will fix it.

## Step 4: Restart AWCC (if it was the cause)

After WMI is back (or after reboot), open **Services**:
- Press Windows key, type `services.msc`, press Enter
- Double-click **AWCC Service**
- Click **Stop**
- Click **Start**

This resets the memory leak. It will leak again over days/weeks.

## Prevention: AWCC on Manual startup

In **Services** (`services.msc`):
1. Double-click **AWCC Service**
2. Change **Startup type** dropdown to **Manual**
3. Click **OK**

This stops AWCC from auto-starting at boot. No tray icon, no memory leak.

**When you need it** (Civ VII, BERT training, any GPU-heavy work):
- Open **Alienware Command Center** from Start menu
- Set thermal profile to Performance
- Close it when done (or leave it — it won't leak in one session)

**What you lose:** Custom fan curves and thermal profiles don't apply until you manually open AWCC. Built-in GPU driver and BIOS thermal management still prevent overheating — worst case the GPU throttles slightly earlier under sustained load.

## Also check

- **Orphaned PowerShell processes** from cron jobs that didn't exit:
  ```bash
  powershell -NoProfile -Command 'Get-Process powershell -EA 0 | Select-Object Id,StartTime | Format-Table -Auto'
  ```
  Kill any that are hours old: `MSYS_NO_PATHCONV=1 taskkill /PID <id> /F`

- **Process count** (should be under 250 for healthy WMI):
  ```bash
  powershell -NoProfile -Command '(Get-Process).Count'
  ```
