#!/usr/bin/env bash

# du -sh {dir} show size of directory

# LC_COLLATE=C = dont ignore dots when sorting
# A = show hidden files
# h = humain readable
# p = indicator for dirs (/)
# v = natural sort of (version) numbers within text
# group-directories-first = pretty explicit
# time-style=iso = show either Y-M-D or M-D H:m depending if current year or not
# color=always = forces color
# sed -> removes the second argument (number of hard links)
ll() {
	LC_COLLATE=C ls -lAhpv --group-directories-first --time-style=iso --color=always $@
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

git() {
	if [[ $@ == "pr" ]]; then
		command git pull --rebase
		# if the rebase did not work do git rebase --abort
	else
		command git "$@"
	fi
}

cbonsai() {
	if [[ $@ != "" ]]; then
		command cbonsai "$@"
		return
	fi

	# gen colors
	leafs_dark=$((1 + "$RANDOM" % 7))

	bark_dark=$((1 + ("$leafs_dark" + "$RANDOM") % 7))
	while [[ bark_dark == leafs_dark ]]; do
		bark_dark=$((1 + ("$leafs_dark" + "$RANDOM") % 7))
	done

	leafs_light=$(("$leafs_dark" + 8))
	bark_light=$(("$bark_dark" + 8))

	command cbonsai -S --time=0.05 --wait=5 --base=2 --leaf="$" --color="$leafs_dark,$bark_dark,$leafs_light,$bark_light" --multiplier=9 --life=45
}

batdiff() {
	git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
}

# colored man page, look https://github.com/sharkdp/bat?tab=readme-ov-file#man
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
# overide --help to use bat
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias v="nvim"
alias vim="nvim"
alias ff="fastfetch"
alias gs="git status"
alias lt='tree -a --dirsfirst -I .git/'
alias python="python3"
alias t="tmux attach"
alias c="clear"
alias nrs="nh os switch /etc/nixos --ask"
