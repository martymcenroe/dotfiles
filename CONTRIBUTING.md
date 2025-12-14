# Contributing to Dotfiles

## Core Philosophy
1. **Idempotency is King:** Every script must be safe to run 100 times in a row. If a script fails because a folder already exists, it is rejected.
2. **Zero Global Pollution:** We do not modify system files unless absolutely necessary. Use \`pipx\`, \`poetry\`, and local configs.
3. **OS Isolation:**
   - Windows logic goes in \`windows/\` (PowerShell preferred).
   - macOS logic goes in \`macos/\` (Zsh/Bash).
   - Shared logic goes in \`common/\` or the root \`install.sh\` (if POSIX compliant).

## Pull Request Standards
* **Linear History:** Rebase before merging. No merge commits.
* **Line Endings:** Respect \`.gitattributes\`. LF for scripts, even on Windows.
* **Testing:** You must verify your changes do not break the "One Command" setup on a fresh VM.

## Directory Structure
* \`home/\`: Generic dotfiles intended for the user's \$HOME directory.
* \`windows/\`: Windows-specific setup (Registry hacks, Winget manifests).
* \`macos/\`: macOS-specific setup (Brewfiles, defaults write).