#
# aliases
#

# References
# - https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.vh7hhm6th
# - https://github.com/webpro/dotfiles/blob/master/system/.alias
# - https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh
#

# single character shortcuts - be sparing!
alias _=sudo
alias g=git

# mask built-ins with better defaults
# Note: modern tool replacements are in modern-tools.zsh
# ping is replaced by gping in modern-tools.zsh
alias vi=vim
alias nv=nvim

# ls aliases are handled by eza in modern-tools.zsh
# Keeping these as fallbacks if eza is not available
if ! command -v eza &>/dev/null; then
  alias l=ls
  alias ll='ls -lh'
  alias la='ls -lAh'
  alias lsa="ls -aG"
  alias ldot='ls -ld .*'
fi

# fix typos
alias get=git
alias quit='exit'
alias cd..='cd ..'
alias zz='exit'

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# date/time
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"
alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
alias utc="date -u +%Y-%m-%dT%H:%M:%SZ"
alias unixepoch="date +%s"

# find - fd tool handles this in modern-tools.zsh
# alias fd='find . -type d -name'
# alias ff='find . -type f -name'

# disk usage - dust/duf tools handle this in modern-tools.zsh
# Keeping these as fallbacks if modern tools are not available
if ! command -v dust &>/dev/null; then
  alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
  alias dux='du -x --max-depth=1 | sort -n'
  alias dud='du -d 1 -h'
  alias duf='du -sh *'
fi

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias please=sudo
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zbench='for i in {1..10}; do /usr/bin/time env ZSH_BENCHMARK_MODE=1 zsh -lic exit; done'
alias cls="clear && printf '\e[3J'"

# print things
alias print-fpath='for fp in $fpath; do echo $fp; done; unset fp'
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

# todo-txt
alias t="todo.sh"
alias todos="$VISUAL $HOME/Desktop/todo.txt"

# auto-orient images based on exif tags
alias autorotate="jhead -autorot"

# process search with auto-filtering of rg itself
pps() {
  ps aux | rg "$@" | rg -v rg
}

# Pi Coding Agent extensions
_PI_EXT="/Users/lecoqjacob/Developer/pi-vs-claude-code/extensions"
alias pi-min="pi -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-focus="pi -e $_PI_EXT/pure-focus.ts"
alias pi-team="pi -e $_PI_EXT/agent-team.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-safe="pi -e $_PI_EXT/damage-control.ts -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-tasks="pi -e $_PI_EXT/tilldone.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-coms="pi -e $_PI_EXT/coms-net.ts -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"

# Quick alias for Claude Code
alias cc='claude'
# Claude Code with skip permissions for trusted projects.
# Was `ccs`; that name is now the CCS (Claude Codex Switch) binary.
alias ccy='claude --dangerously-skip-permissions'
