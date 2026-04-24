# Process Defender TUI

A Windows-focused process monitor with a terminal UI, policy-based alerts, and optional VirusTotal reputation checks.

## Features

- Shows live process name, PID, CPU %, memory usage, executable path, policy status, and VirusTotal status
- Calculates SHA-256 hashes for executable files
- Looks up executable reputation with the VirusTotal API v3
- Applies editable rules from `policy.json`
- Writes alerts and actions as JSONL logs
- Runs in safe dry-run mode by default
- Can optionally kill, suspend, dump memory, and quarantine when started with `--execute`

## Install

```powershell
.\install.ps1
```

Manual install:

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
py -m pip install -r requirements.txt
```

## VirusTotal API Key

Set the key in the same terminal before starting the monitor:

```powershell
$env:VIRUSTOTAL_API_KEY = "paste_key_here"
```

The app reads `VIRUSTOTAL_API_KEY` from the process environment.

To set it persistently for future terminal sessions:

```powershell
setx VIRUSTOTAL_API_KEY "paste_key_here"
```

After using `setx`, open a new terminal before starting the monitor.

Keep your VirusTotal key private. Do not commit it or hard-code it into scripts. The default policy does not upload unknown files, and the default `rate_limit_seconds` value is `16`, which keeps lookups under the free public API limit of 4 requests per minute. Free public API access is for personal, non-commercial use.

## Run

Safe dry-run mode:

```powershell
.\launch.ps1
```

Dry-run mode logs matching policy actions without killing, suspending, dumping, or quarantining processes.

Explicit dry-run mode:

```powershell
.\launch.ps1 -DryRun
```

Run in the current terminal instead of opening Windows Terminal panes:

```powershell
.\launch.ps1 -DryRun -CurrentTerminal
```

Execute mode:

```powershell
.\launch.ps1 -Execute
```

Use execute mode only in a lab VM. Run from an elevated terminal if process-control actions need to work reliably.

## Scan a File

```powershell
.\launch.ps1 -ScanFile .\path\to\file.exe
```

The launcher also accepts `-Policy`, `-Workdir`, `-Interval`, and `-MaxRows`.

## Logs

Default data folder:

```text
.\defender_data\
```

Log files:

```text
defender_data\logs\alerts.jsonl
defender_data\logs\actions.jsonl
defender_data\logs\virustotal.jsonl
defender_data\logs\manual_scan.jsonl
```

Tail logs:

```powershell
.\.venv\Scripts\python.exe process_defender.py tail --log alerts
.\.venv\Scripts\python.exe process_defender.py tail --log actions
.\.venv\Scripts\python.exe process_defender.py tail --log virustotal
```

## Policy

Edit `policy.json` to change thresholds, rules, and actions.

Example rule:

```json
{
  "id": "memory-over-threshold",
  "description": "If RSS memory is over 500 MB, log a warning.",
  "when": { "memory_mb_gt": 500 },
  "actions": ["log_warning"]
}
```

Supported conditions:

- `process_name_equals`
- `memory_mb_gt`
- `vt_detections_gt`

Supported actions:

- `log_warning`
- `kill`
- `suspend`
- `dump_memory`
- `quarantine`

## ProcDump

Memory dumping requires Sysinternals ProcDump. Put `procdump.exe` next to this script, in `PATH`, or set the path in `policy.json`:

```json
"dump": {
  "procdump_path": "C:\\Tools\\ProcDump\\procdump.exe",
  "dump_folder": "dumps"
}
```
