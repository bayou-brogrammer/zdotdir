#
# peekaboo
#

[[ ${ZSH_ENABLE_PEEKABOO:-1} -eq 1 ]] || return

if (( $+commands[peekaboo] )); then
  eval "$(peekaboo completions zsh 2>/dev/null)"
fi
