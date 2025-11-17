# ⚡ Windows 11 Dev Setup: Zero to Production in One Command

**The Problem:** Setting up Windows for serious Python development is a nightmare. Microsoft Store Python stubs. PATH conflicts. Manual tool installation. Lost shell history. Hours of your life, every time you touch a new machine.

**The Solution:** One bash script. Five minutes. Done.

```bash
./install.sh  # That's it. Your machine is now configured.
```

---

## What Gets Installed & Configured

✅ **Python 3.14 + 3.13** (N-2 policy) with working `python3` alias  
✅ **Poetry & pipx** (proper PATH, no manual registry edits)  
✅ **VSCode** with 20+ production extensions (Python, Docker, Cloud, Security)  
✅ **Git, GitHub CLI, Docker, SonarQube, jq, tree**  
✅ **Persistent bash history** (survives reboots)  
✅ **Windows Terminal settings** (pre-configured)  

**No WSL. No VMs. Native Windows with POSIX-like workflow.**

---

## Why Trust This?

Built by a former **AT&T Director of Data Science & AI** (29 years, 21 patents, $9M team budget).  
Licensed **Professional Engineer** (Texas EE).  
Battle-tested in production. Zero guesswork.

This isn't a hobbyist config — it's enterprise-grade automation for people who ship code.

---

## Quick Start

### 1️⃣ Bootstrap (PowerShell)
```powershell
winget install --id Git.Git -e
git clone https://github.com/martymcenroe/dotfiles.git
cd dotfiles
.\windows\setup-env.ps1  # Fix system PATH, then restart terminal
```

### 2️⃣ Install Everything (Git Bash)
```bash
./install.sh  # Installs tools, fixes Python, deploys configs
```

### 3️⃣ Save Changes Later
```bash
./save.sh  # Auto-commits and pushes your config updates
```

---

## The Tech Stack This Enables

![Python](https://img.shields.io/badge/Python-3.14%20%7C%203.13-blue?logo=python)
![Poetry](https://img.shields.io/badge/Poetry-package%20manager-blue)
![Docker](https://img.shields.io/badge/Docker-containerization-blue?logo=docker)
![VSCode](https://img.shields.io/badge/VSCode-configured-blue?logo=visualstudiocode)

**ML/AI:** PyTorch • TensorFlow • LangChain • Hugging Face  
**Cloud:** AWS (SageMaker, Bedrock) • Azure (ML, DevOps) • Snowflake (Cortex AI)  
**DevOps:** GitHub Actions • SonarQube • MLflow  
**Security:** OWASP • Penetration Testing • CISSP-grade configs

See the [full stack here](#) if you're into that sort of thing.

---

## Architecture Choice: Windows Native vs WSL

**WSL:** Full Linux VM. Clean, but slow file I/O, higher resource usage, complexity overhead.

**This Repo:** Native Windows with Git Bash + Poetry. Lighter, faster, zero VM tax. If you need Linux, use Linux. If you're on Windows, this is the professional path.

---

## What's Inside

| File | Purpose |
|------|---------|
| `install.sh` | One-command bootstrap for new machines |
| `save.sh` | Daily driver: backs up local configs to repo |
| `home/.bash_profile` | Persistent history, clean PATH |
| `windows/setup-env.ps1` | Fixes Windows PATH conflicts |

---

## Contributing

Found a bug? Open an issue.  
Have a better approach? PR welcome.  
Just like clean automation? **⭐ Star this repo.**

---

## License

MIT. Use it. Fork it. Star it if it saved you time.

---

**Built by [Marty McEnroe](https://www.linkedin.com/in/martymcenroe)** | Former AT&T Director of Data Science & AI | Licensed PE (Texas EE) | 29 years shipping production ML systems

⭐ **If this saved you 2+ hours of Windows dev setup headaches, star this repo.** It's the GitHub equivalent of buying me a coffee, except free.

---

**Current Status:** Production-ready. I use this daily. Your mileage may vary, but probably won't.