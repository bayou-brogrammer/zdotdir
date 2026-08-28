#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Profiling
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#
# Interactive TTYs only: gitstatusd needs `setopt monitor` (job control), which
# zsh cannot enable without a controlling terminal. Callers that spawn an
# interactive login shell over plain pipes (e.g. Electron's child_process) hit
# "can't change option: monitor", and gitstatus then hangs retrying rather than
# failing fast. ZSH_INTERACTIVE_TTY is set in .zshenv; `p10k finalize` below is
# gated on the same flag so instant prompt is never left un-finalized.
if (( ${ZSH_INTERACTIVE_TTY:-0} )); then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# Add Hermes tooling (uv) to PATH
export PATH="$HOME/.hermes/bin:$PATH"

# Antibody compatibility shim → resolves clone/path/bundle directly so
# startup is instant. The real autoloaded `antidote` boots the whole
# framework + spawns git on every call (~4s each); this shim short-
# circuits the calls that fire on every shell start.
#
# The real framework is bootstrapped lazily, only for genuine misses
# (non-clone bundle generation, `antidote update`, etc.).
_antidote_real() {
  (( ${+functions[antidote-dispatch]} )) || \
    builtin source "${ANTIDOTE_REPO:-$ZDOTDIR/.antidote}/antidote.zsh"
  antidote-dispatch "$@"
}
antibody() {
  case "${1:-}" in
    init) ;;  # `source <(antibody init)` → no-op; we define antidote ourselves
    bundle)
      local repo="${@:2}"
      repo="${repo%% *}"
      local repo_path="${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/repos}/github.com/$repo"
      # kind:clone only ensures the repo is cloned — skip if already present
      [[ "$*" == *"kind:clone"* && -d "$repo_path/.git" ]] && return 0
      # Cache the load script for non-clone bundles
      local key="${(j:_:)${@:2}//[^a-zA-Z0-9._-]/_}"
      local cache="$ZSH_CACHE_DIR/antibody-bundle-$key.zsh"
      if [[ ! -s $cache ]]; then
        mkdir -p "${cache:h}"
        _antidote_real bundle "${@:2}" >| "$cache"
      fi
      source "$cache"
      ;;
    path)
      local repo="${@:2}"
      repo="${repo%% *}"
      print -r "${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-$HOME/.cache}/repos}/github.com/$repo"
      ;;
    *) _antidote_real "$@" ;;
  esac
}
# A fake `commands[antibody]=antibody` hash entry gets silently wiped by
# any later `path`/`PATH` reassignment (e.g. zshrc1's prepath merge below),
# which zsh treats as a signal to invalidate the whole command hash table.
# A real (never-executed — the function above always wins on lookup) stub
# file on $PATH survives that invalidation, since zsh re-resolves it from
# disk instead of relying on the manual poke.
if [[ ! -x "$ZSH_CACHE_DIR/shims/antibody" ]]; then
  mkdir -p "$ZSH_CACHE_DIR/shims"
  : >| "$ZSH_CACHE_DIR/shims/antibody"
  chmod +x "$ZSH_CACHE_DIR/shims/antibody"
fi
path=("$ZSH_CACHE_DIR/shims" $path)

# Plugins for zsh_custom
plugins=(
  azure
  clipboard
  common-aliases
  common-functions
  completions
  compstyle
  confd
  # direnv: handled by conf.d/direnv.zsh, which caches the hook instead of
  # forking `direnv hook zsh` on every startup.
  dotfiles
  dotnet
  extract
  git
  git-cmds
  iwd
  jupyter
  perl
  prj
  python
  ruby
  xdg-apps
)

# Route zsh_custom's vendored init/antidote.zsh through the antibody shim
# above. Without this it takes the `else` branch: sources the 61KB antidote
# framework + runs `source <(antidote init)` + spawns the framework for every
# `antidote bundle/path` call — ~4s/shell each. The antibody branch is a
# complete no-op here (commands[antibody] is already defined by the shim).
zstyle ':zsh_custom:antidote' use-antibody yes

# Create an amazing Zsh config using antidote plugins.
source $ZDOTDIR/lib/antidote-fast.zsh

# ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/zcompdump
# compinit -i -d "$ZSH_COMPDUMP"

# # Set prompt
# autoload -Uz promptinit && promptinit
# setopt transient_rprompt
# prompt z1

# .p10k.zsh is sourced by conf.d/prompt.zsh (loaded above via the confd plugin),
# so sourcing it again here just re-read 92KB on every shell. Only finalize.
if (( ${ZSH_INTERACTIVE_TTY:-0} )); then
  (( ! ${+functions[p10k]} )) || p10k finalize
fi

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# Local settings
[ -r $HOME/.local/config/zsh/.zshrc.local ] \
&& . $HOME/.local/config/zsh/.zshrc.local

# Finish profiling by calling zprof.
[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC

# Always return success
true
