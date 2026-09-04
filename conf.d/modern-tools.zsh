#!/bin/zsh
#
# modern-tools.zsh - Modern CLI tool aliases and configurations
#

[[ -o interactive ]] || return

# Batch-check which modern tools are available (single hash lookup each, no fork)
typeset -gA _have
for _tool in eza bat rg fd dust duf procs btm delta doggo hexyl tldr gping lazygit difftastic difft ouch jless watchexec dua bandwhich choose hyperfine tokei zoxide; do
  (( $+commands[$_tool] )) && _have[$_tool]=1
done

# Use modern tools if available
if [[ -n ${_have[eza]:-} ]]; then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -l --group-directories-first --icons --git'
  alias la='eza -la --group-directories-first --icons --git'
  alias lsa='eza -a --group-directories-first --icons'
  alias ldot='eza -ld --git .*'
  alias lt='eza --tree --level=2 --icons'
  alias tree='eza --tree --icons'
  alias l='eza --group-directories-first --icons'
fi

if [[ -n ${_have[bat]:-} ]]; then
  alias cat='bat --paging=never'
  alias ccat='/bin/cat'  # Preserve original cat
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="Monokai Extended"
  export BAT_STYLE="numbers,changes,header"
fi

if [[ -n ${_have[rg]:-} ]]; then
  alias grep='rg'
  alias ggrep='/usr/bin/grep'  # Preserve original grep
fi

if [[ -n ${_have[fd]:-} ]]; then
  alias find='fd'
  alias ffind='/usr/bin/find'  # Preserve original find
fi

if [[ -n ${_have[dust]:-} ]]; then
  alias du='dust'
  alias ddu='/usr/bin/du'  # Preserve original du
fi

if [[ -n ${_have[duf]:-} ]]; then
  alias df='duf'
  alias ddf='/bin/df'  # Preserve original df
fi

if [[ -n ${_have[procs]:-} ]]; then
  alias ps='procs'
  alias pps='/bin/ps'  # Preserve original ps
fi

if [[ -n ${_have[btm]:-} ]]; then
  alias top='btm'
  alias htop='btm'
  alias ttop='/usr/bin/top'  # Preserve original top
fi

if [[ -n ${_have[delta]:-} ]]; then
  export GIT_PAGER='delta'
fi

# if command -v xh &>/dev/null; then
#   alias curl='xh'
#   alias ccurl='/usr/bin/curl'  # Preserve original curl
#   alias http='xh'
#   alias https='xh --https'
# fi

if [[ -n ${_have[doggo]:-} ]]; then
  alias dig='doggo'
  alias ddig='/usr/bin/dig'  # Preserve original dig
fi

if [[ -n ${_have[hexyl]:-} ]]; then
  alias xxd='hexyl'
  alias hd='hexyl'
fi

if [[ -n ${_have[tldr]:-} ]]; then
  alias help='tldr'
  alias man='tldr'
fi

if [[ -n ${_have[gping]:-} ]]; then
  alias ping='gping'
  alias pping='/sbin/ping'  # Preserve original ping
fi

if [[ -n ${_have[lazygit]:-} ]]; then
  alias lg='lazygit'
fi

# Disabled: sd has different syntax than sed and breaks VSCode shell integration
# if command -v sd &>/dev/null; then
#   alias sed='sd'
#   alias ssed='/usr/bin/sed'  # Preserve original sed
# fi

# Git aliases with modern tools
if [[ -n ${_have[delta]:-} ]]; then
  alias gdiff='git diff'
  alias gshow='git show'
fi

if [[ -n ${_have[difft]:-} ]]; then
  alias gdifft='git difftool --tool=difftastic'
  alias difftastic='difft'  # Alias for convenience
fi

alias glog='git log --oneline --graph --decorate --all'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'

# Compression/decompression (ouch handles zip, tar, gz, bz2, xz, 7z, etc.)
if [[ -n ${_have[ouch]:-} ]]; then
  alias compress='ouch compress'
  alias decompress='ouch decompress'
  alias lsarchive='ouch list'
fi

# Interactive JSON viewer
if [[ -n ${_have[jless]:-} ]]; then
  alias jv='jless'
fi

# File watcher - run commands on file changes
if [[ -n ${_have[watchexec]:-} ]]; then
  alias watch='watchexec'
fi

# Interactive disk usage (complements dust for exploration)
if [[ -n ${_have[dua]:-} ]]; then
  alias dui='dua interactive'
fi

# Bandwidth monitor by process
if [[ -n ${_have[bandwhich]:-} ]]; then
  alias bwich='sudo bandwhich'
fi

# Friendlier cut/awk for field extraction
if [[ -n ${_have[choose]:-} ]]; then
  alias field='choose'
fi

# Quick benchmarking
if [[ -n ${_have[hyperfine]:-} ]]; then
  alias bench='hyperfine'
fi

# Code statistics
if [[ -n ${_have[tokei]:-} ]]; then
  alias cloc='tokei'
  alias loc='tokei'
fi

# Zoxide aliases are configured in conf.d/zoxide.zsh
if [[ -n ${_have[zoxide]:-} ]]; then
  alias cd='z'
  alias ccd='builtin cd'  # Preserve original cd
  alias zi='zi'  # Interactive zoxide
fi

# Better file operations
alias cp='cp -iv'  # Interactive, verbose
alias mv='mv -iv'  # Interactive, verbose
alias rm='rm -i'   # Interactive
alias mkdir='mkdir -pv'  # Create parent dirs, verbose

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

unset _have _tool
