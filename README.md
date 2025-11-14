# My Dotfiles

This repository contains my personal machine configurations (dotfiles).

It's designed to be automated, allowing for:

1.  **Fast Setup:** Running `install.sh` on a new machine to apply all my preferences.
2.  **Easy Updates:** Running `save.sh` to back up any new changes to this repository.

## New Machine Setup

On a new machine, follow these steps *in order*.

### Step 1: Install Git & Clone Repo

Open a new PowerShell terminal and run:

```powershell
winget install --id Git.Git -e --source winget
git clone https://github.com/martymcenroe/dotfiles.git
cd dotfiles
```

### Step 2: Configure Windows Environment

Run the one-time environment setup script. This configures system-level settings, like the `PATH`.

**Right-click `windows\setup-env.ps1` and select "Run with PowerShell"** or run the following in your terminal. You may need to temporarily change your execution policy.

```powershell
# If you get an error, run this first:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\windows\setup-env.ps1
```

**After this script runs, you MUST close and re-open your terminal.**

### Step 3: Install Apps & Apply Configs

After re-opening your terminal (now as **Git Bash**), run the main installer script:

```bash
# This script installs all your apps and copies your configs
./install.sh
```

## Updating Configs (Daily Workflow)

After making a change to a local config (like in Windows Terminal), run the `save.sh` script to commit and push the changes back to this repo.

```bash
./save.sh
```
