# zz-warp-debug.zsh — TEMPORARY instrumentation for Warp double-execution.
# Active only in Warp ($TERM_PROGRAM == WarpTerminal). Delete once diagnosed.
# v2: counting only — no widget wrapping (v1 recursed with fast-syntax-highlighting).
[[ "$TERM_PROGRAM" == "WarpTerminal" ]] || return 0
[[ -o interactive ]] || return 0

zmodload zsh/datetime

typeset -g _WDBG_LOG="$ZSH_CACHE_DIR/warp-debug.log"
_wdbg() { print -r -- "[$EPOCHREALTIME pid=$$] $*" >> "$_WDBG_LOG" }

_wdbg "=== rc-load: zsh=$ZSH_VERSION ZDOTDIR=$ZDOTDIR warp_fns(warp_preexec=$(( $+functions[warp_preexec] )) warp_precmd=$(( $+functions[warp_precmd] )))"
_wdbg "    ^M emacs -> $(bindkey -M emacs '^M' 2>/dev/null)  |  ^M viins -> $(bindkey -M viins '^M' 2>/dev/null)"

autoload -Uz add-zsh-hook
_wdbg_preexec() {
  emulate -L zsh
  _wdbg "PREEXEC cmd=[$1]"
}
_wdbg_precmd() {
  emulate -L zsh
  _wdbg "PRECMD (prompt ready)"
}
add-zsh-hook preexec _wdbg_preexec
add-zsh-hook precmd _wdbg_precmd
