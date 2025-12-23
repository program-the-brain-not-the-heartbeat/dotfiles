alias cpv='rsync -ah --info=progress2'   # cp with progress
alias rsync-copy="rsync -av --progress -h --exclude-from=$HOME/.cvsignore"
alias rsync-move="rsync -av --progress -h --remove-source-files --exclude-from=$HOME/.cvsignore"
alias rsync-update="rsync -avu --progress -h --exclude-from=$HOME/.cvsignore"
alias rsync-synchronize="rsync -avu --delete --progress -h --exclude-from=$HOME/.cvsignore"
