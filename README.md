# .configs-bak

Automatic Git backup of Neovim, PowerShell, and WezTerm configs on Windows.

![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D6)
![PowerShell](https://img.shields.io/badge/PowerShell-7-5391FE)
![Neovim](https://img.shields.io/badge/Neovim-Lua-57A143)
![WezTerm](https://img.shields.io/badge/WezTerm-Lua-4E49EE)

Most dotfile tools assume Linux or macOS and symlinks.
This repo uses two small PowerShell scripts and the Windows Task Scheduler instead.
Every 15 minutes, it copies the live configs here, then commits and pushes the changes.
You edit your configs in the usual place. The history is saved on GitHub without extra work.

## Features

- **No symlinks.** The live configs stay where the tools expect them. The repo holds a copy.
- **Runs in the background.** A scheduled task starts at logon and every 15 minutes. No window opens.
- **No noise.** If nothing changed, no commit is made.
- **Readable history.** Each commit names the configs that changed, for example
  `sync: 2026-10-23 21:27 (powershell, wezterm)`.
- **Mirror copy.** A file that you delete from a live config is also deleted from the backup.
- **Small.** Two scripts, no dependencies except PowerShell 7 and Git.
- **Works for any tool.** Add a line to `.env` and a name to `sync.ps1` to back up another config.

## Quick start

Requirements: Windows 10/11, PowerShell 7 (`pwsh`), and Git that can push without a prompt
(for example Git Credential Manager, or `gh auth login`).

```powershell
git clone https://github.com/<you>/.configs-bak.git
cd .configs-bak
Remove-Item -Recurse .neovim, .powershell, .wezterm   # remove my backups
notepad .env                                           # add your paths (see below)
pwsh -NoProfile -File .\sync.ps1                       # run one sync, then check sync.log
pwsh -NoProfile -File .\register-task.ps1              # install the scheduled task
```

> [!WARNING]
> Do not back up files that contain secrets, such as API keys or tokens.
> If your repo is public, everyone can read every synced file and its full history.

The full steps are in [Use it yourself](#use-it-yourself).

## What is in my setup

| Tool | Highlights |
|---|---|
| **Neovim** | [lazy.nvim](https://github.com/folke/lazy.nvim), tokyonight, LSP with mason, nvim-cmp, Treesitter, Telescope, neo-tree and oil, Neogit with diffview and gitsigns, snacks dashboard with One Piece art, claudecode.nvim |
| **PowerShell** | oh-my-posh prompt (`mohak.omp.json`), zoxide, WezTerm tab title integration |
| **WezTerm** | JetBrainsMono Nerd Font, tokyonight_night, `pwsh` as the default shell, pane and tab keybindings |

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

## Troubleshooting

Look in `sync.log` first. Each sync that fails writes a line that starts with `ERROR:`.

| Problem | Fix |
|---|---|
| `ERROR: git push failed` | Git cannot push without a prompt. Run `git push` once by hand and log in, or run `gh auth login`. |
| `skip <name>: source '...' not found` | The path in `.env` is wrong, or the name is missing from `.env`. |
| `robocopy failed for <name>` | A file in the source is locked or you have no access. Close the tool and run a sync again. |
| No new commits, no errors | Nothing changed, or the task does not run. Check `Get-ScheduledTaskInfo ConfigsBackupSync`. |
| The task stopped after a PowerShell update | Run `register-task.ps1` again to update the path of `pwsh.exe`. |

## Restore

Copy the backup back to its source path. For example:

```powershell
robocopy .\.neovim $env:LOCALAPPDATA\nvim /E
Copy-Item .\.wezterm\.wezterm.lua $HOME\
Copy-Item .\.powershell\* $HOME\.config\powershell\ -Recurse
```

To restore an older version, find the commit with `git log -- .neovim`,
then run `git checkout <commit> -- .neovim` before you copy.
