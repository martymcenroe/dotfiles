# Marty's Windows 11 dotfiles: The Friction-Removal Kit

This repository contains my professional configuration files (\`dotfiles\`) for a robust, automated Windows 11 development environment.

## The "Why" (The Friction)

Setting up a new Windows 11 machine for professional Python development is a "morass" of friction. You have to fight:

* **The "Stub" misdirection:** The Microsoft Store injecting "stub" versions of \`python.exe\`.
* **The "Opposite Behavior":** Windows using \`python\` while macOS/Linux use \`python3\`.
* **The "Manual Toil":** Manually installing all your core tools (Git, VSCode, Sublime, Poetry) one by one.
* **The "Lost History":** The default Git Bash terminal losing your command history on every reboot.

This repository *solves* this. It's an automated, one-command system to build a clean, professional, and cross-platform-friendly environment.

## The Solution: One-Command Setup

This architecture is 100% automated. On a new machine, you run one script (\`install.sh\`) that:

1.  **Installs All Tools:** Uses `winget` to silently install Git, VSCode, Sublime, Poetry, GitHub CLI, and more.
2.  **Fixes the "Python Mess":** Automatically creates the \`python3.exe\` alias to shadow the Microsoft Store stubs, mirroring a macOS/Linux environment.
3.  **Fixes History:** Deploys a `.bash_profile` that gives you persistent, robust command history.
4.  **Deploys Configs:** Installs a secure `.gitattributes` file, your complete VSCode extension list, and your Windows Terminal settings.

## Architectural Choice: "Windows Native" vs. WSL

This `dotfiles` system represents a deliberate architectural choice. We are *not* using the Windows Subsystem for Linux (WSL).

* **WSL (The Alternative):** WSL provides a *full Linux kernel* inside a VM. This is a powerful, 100% "friction-free" Linux environment, but it comes with the architectural overhead of a complex VM, a slow bridge between two different file systems, and higher resource usage.
* **Our "Windows Native" Path (This Repo):** We have chosen a lighter, faster, "native" path. We use `git-bash` and `poetry` to *architect* a POSIX-like environment *on* Windows, rather than *isolating* ourselves within a VM. The scripts in this repo are the "friction-removal" IP that make this native path not only viable, but professional and efficient.

## Features

* **`install.sh`:** The main bootstrap script. Run it once on a new machine.
* **`save.sh`:** Your "daily driver." Run `./save.sh` to back up your local configs (like your terminal settings) to this repo with an automated `git push`.
* **`automation-scripts/`:** (Sold separately) A full repo of Python-based utilities for automating your developer life (e.g., auditing GitHub repos).

## New Machine Bootstrap

On a new machine, follow these steps *in order*.

### Step 1: Install Git & Clone Repo (PowerShell)

\`\`\`powershell
winget install --id Git.Git -e --source winget
git clone https://github.com/martymcenroe/dotfiles.git
cd dotfiles
\`\`\`

### Step 2: Configure Windows Environment (PowerShell)

Run the one-time environment setup script to fix the system \`PATH\`.

\`\`\`powershell
# If you get an error, run this first:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\windows\setup-env.ps1
\`\`\`

**After this script runs, you MUST close and re-open your terminal.**

### Step 3: Install Apps & Apply Configs (Git Bash)

After re-opening your terminal (now as **Git Bash**), run the main installer script:

\`\`\`bash
./install.sh
\`\`\`

Your machine is now fully configured. Enjoy the friction-free environment.
