#
# forge-cache: preload forge's shell plugin and theme from a compiled cache.
#
# `forge zsh plugin` forks forge and emits ~167KB of shell to eval; together
# with `forge zsh theme` it cost ~46ms of every interactive startup — the
# single largest item in the trace.
#
# The generated output sets _FORGE_PLUGIN_LOADED / _FORGE_THEME_LOADED itself,
# so sourcing the cache here makes the guards in forge.zsh skip the expensive
# evals. This file sorts before forge.zsh ('-' precedes '.'), which leaves
# forge.zsh untouched and still regenerable by `forge zsh setup`.

[[ -o interactive ]] || return

# forge.zsh (generated, later in conf.d) evals `forge zsh plugin` unguarded.
# Put ~/.local/bin on PATH first (that's where the installer drops it), then
# if forge still isn't a command, mark the generated file's guards so it
# skips instead of printing "command not found: forge".
[[ -d $HOME/.local/bin ]] && path=($HOME/.local/bin $path)
if ! (( $+commands[forge] )); then
  typeset -g _FORGE_PLUGIN_LOADED=1 _FORGE_THEME_LOADED=1
  return
fi
(( $+functions[cached-source] )) || return

# Generated forge scripts call `date` (not /bin/date). Keep /bin on PATH
# even if brew shellenv/path_helper dropped it earlier in startup.
path+=(/bin /usr/bin /usr/sbin /sbin)

cached-source forge-zsh-plugin forge zsh plugin
cached-source forge-zsh-theme forge zsh theme

# If `date` still failed, _FORGE_*_LOADED stay empty and forge.zsh evals the
# same scripts again. Mark loaded so that second eval does not fire.
: "${_FORGE_PLUGIN_LOADED:=1}"
: "${_FORGE_THEME_LOADED:=1}"
