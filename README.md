# Configs Backup

An automatic backup of my Neovim, PowerShell, and WezTerm configs (Windows).
A scheduled task copies the live configs into this repo every 15 minutes.
If something changed, the task commits and pushes the changes to GitHub.

## File structure

```
.configs-bak/
├── .neovim/            # copy of the Neovim config dir (init.lua, lazy-lock.json, lua/)
│   └── lua/
│       ├── config/     # options, keymaps, autocmds
│       ├── plugins/    # one file per plugin group
│       └── art/        # dashboard art
├── .powershell/        # copy of the PowerShell config dir (profile + oh-my-posh theme)
├── .wezterm/           # copy of the WezTerm config file (.wezterm.lua)
├── sync.ps1            # copies the configs, then commits and pushes
├── register-task.ps1   # installs the scheduled task that runs sync.ps1
├── .env                # source paths of the live configs (not committed)
├── sync.log            # result of each sync (not committed)
└── .gitignore
```

Do not edit the files in `.neovim`, `.powershell`, or `.wezterm`.
The next sync replaces them with the live configs.

## How it works

1. The scheduled task `ConfigsBackupSync` starts `sync.ps1` every 15 minutes and at logon.
   It runs through `conhost --headless`, so no window opens.
2. `sync.ps1` reads the source paths from `.env`.
3. For each config:
   - A directory is mirrored with `robocopy /MIR`. Deleted source files are also deleted in the backup.
     `.git` directories and `*.bak*` files are skipped.
   - A single file is copied into its backup directory.
4. The script runs `git add -A`. If nothing changed, it stops. No empty commits are made.
5. Otherwise it commits with a message like `sync: 2026-10-18 12:40 (neovim, wezterm)`
   and runs `git push origin master`.
6. It writes the result, or the error, to `sync.log`.

### `.env` format

One `name=path` line per config. The name is the backup directory without the dot.

```
neovim=C:\Users\<you>\AppData\Local\nvim
powershell=C:\Users\<you>\.config\powershell
wezterm=C:\Users\<you>\.wezterm.lua
```

A path can be a directory or a single file.

## Use it yourself

Requirements: Windows 10/11, PowerShell 7 (`pwsh`), and Git.
Git must be able to push without a prompt (for example Git Credential Manager, or `gh auth login`).

1. Fork this repo, or make a new repo, and clone it:
   ```
   git clone https://github.com/<you>/.configs-bak.git
   cd .configs-bak
   ```
2. Delete my backups: `.neovim`, `.powershell`, `.wezterm`.
3. Create `.env` with your own paths (see the format above).
4. If you back up different tools, change the list of names in `sync.ps1`:
   ```powershell
   foreach ($name in 'neovim', 'powershell', 'wezterm') {
   ```
   Each name must match a key in `.env`.
5. Make sure that your default branch is `master`, or change `git push origin master` in `sync.ps1`.
6. Run one sync by hand and check `sync.log`:
   ```
   pwsh -NoProfile -File .\sync.ps1
   ```
7. Install the scheduled task:
   ```
   pwsh -NoProfile -File .\register-task.ps1
   ```

## Manage the task

| Task | Command |
|---|---|
| Run a sync now | `Start-ScheduledTask ConfigsBackupSync` |
| See the last result | `Get-ScheduledTaskInfo ConfigsBackupSync` |
| See the sync history | `Get-Content sync.log -Tail 20` |
| Remove the task | `Unregister-ScheduledTask ConfigsBackupSync` |

To change the interval, edit `-Minutes 15` in `register-task.ps1` and run it again.

## Restore

Copy the backup back to its source path. For example:

```powershell
robocopy .\.neovim $env:LOCALAPPDATA\nvim /E
Copy-Item .\.wezterm\.wezterm.lua $HOME\
```
