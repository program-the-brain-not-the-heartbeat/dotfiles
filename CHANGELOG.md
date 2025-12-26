## [unreleased]

### 🐛 Bug Fixes

- Tag/release bug on changelog

### 🚜 Refactor

- Redo the git cliff workflow

### ⚙️ Miscellaneous Tasks

- *(changelog)* Update CHANGELOG.md [ci skip]
- *(changelog)* Update CHANGELOG.md [ci skip]
## [1.0.0] - 2025-12-26

### 🚀 Features

- Add nano preferences
- Add kill app by name
- Add rmimages alias
- Reusable function for symlinking files
- Add hot-reloading of bash aliases
- Add some structure for future
- Add ssh config and glob linking (untested)
- Add sk suffix for dircolors for private keys ending in "_sk"
- Add tmux config
- Add htop
- Cpe
- Quick bootstrap command
- Add batcat for pagers
- B and mount-missing
- Add reload bashrc
- Add install default packages
- Add some paths
- Paths
- Umask
- Www2 aliases
- Lesspipe
- History timestamp
- Composer home
- Script folder
- Admin group
- Update browserlist
- Add modular bashrc
- Add xdg cache for composer
- Disallow composer on root
- Add zfs aliases
- Record spaces too
- Add systemd aliases
- Add rootgrep alias and php functions
- Add dev server defaults
- Add final message
- Ansi art
- Scrub-disk script
- Quiet apt upgrade
- Quiet git clone
- Add root variable
- Show hidden files by default
- Refetch latest dotfiles alias
- *(bootstrap)* Accept --yes/-y to auto-confirm install prompt
- Fallback
- Add tree
- Concat aliases into ~/.bash_aliases
- Install system scripst into /usr/local/sbin

### 🐛 Bug Fixes

- Nano syntax loading
- Wrong destination for tmux
- Broken nano symlink
- Typo
- Another typo
- Bad parameters
- Remove broken alias
- Bash prompt unset variable
- Unset variable
- Variable
- Default variable
- Variable
- Variable
- Remove unnecessary
- Broke exit code on override
- Install issues
- No yq in apt
- Error on existing groups
- Don't die if acl not enabled
- Comment out nano stuff for < 7.0
- Still loading theme on *.nanorc
- Path bug
- Path bug
- *(dotshell)* Always pass --yes in dotfiles helper
- Updated workflow
- Cleanup changelog.md
- *(test)* Add dummy entry for changelog test
- Don't override specific commands if inside vscode
- Broken aliases for mount drive
- Use default git-cliff config
- Changelog generator
- Changelog generator
- Changelog generator

### 💼 Other

- Cleanup bash completion

### 🚜 Refactor

- Remove old bashrc
- Move prod alias
- Rework bash aliases generation

### 📚 Documentation

- Add tmux cheatsheet

### ⚙️ Miscellaneous Tasks

- *(changelog)* Add initial CHANGELOG.md
- *(changelog)* Use git-cliff to generate changelog
- Trigger changelog workflow (manual)
- *(changelog)* Cache cargo and fix heredoc
- Trigger changelog workflow (cache test)
- *(changelog)* Add initial CHANGELOG.md
- Trigger update-changelog workflow (manual)
- *(changelog)* Fix printf syntax in workflow
- *(changelog)* Avoid set-output by installing rustup and using GITHUB_PATH
- *(changelog)* Cache before install and skip install if cached
- *(changelog)* Add .gitcliff.toml and use it to include all commits in Unreleased
- *(changelog)* Fix git-cliff --prepend usage
- Trigger changelog workflow (fix prepend)
- *(changelog)* Fix .gitcliff.toml quoting for regexes
- *(changelog)* Generate Unreleased with git-cliff (-u)
- *(changelog)* Update CHANGELOG.md [ci skip]
