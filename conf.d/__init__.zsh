#
# __init__: This runs prior to any other conf.d contents.
#

# Apps
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# Set the list of directories that cd searches.
cdpath=(
  $XDG_PROJECTS_DIR(N/)
  $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
  # core
  $prepath
  $path

  # emacs
  $HOME/.emacs.d/bin(N)
  $XDG_CONFIG_HOME/emacs/bin(N)
)

# Keep these arrays unique to avoid bloating PATH/FPATH on repeated loads.
# -g is REQUIRED: run_confd sources this file from inside a function, and
# typeset without -g would create a function-local (empty!) `path` that
# shadows the global one for every later conf.d file — silently killing
# every `command -v` check, incl. the eza aliases in modern-tools.zsh.
typeset -gU path fpath cdpath

# Keep completion dumps in cache, not $HOME.
ZSH_COMPDUMP=${ZSH_COMPDUMP:-$ZSH_CACHE_DIR/.zcompdump}

# Helper: source a file and export all variables it defines.
load_exports_file() {
  local file=$1
  [[ -r $file ]] || return 1
  set -a; source "$file"; set +a
}
