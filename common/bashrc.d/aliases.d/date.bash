alias now='date +"%Y-%m-%d %H:%M:%S"'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'

alias nows='date "+%F %T"'
alias nowh='date "+%-I:%M %p" | tr "[:upper:]" "[:lower:]"'

epoch() {
	local num=${1:--1}
	printf '%(%B %d, %Y %-I:%M:%S %p %Z)T\n' "$num"
}
