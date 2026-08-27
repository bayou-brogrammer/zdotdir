#
# cache-helpers: source expensive tool init from a byte-compiled cache.
#

# cached-source <name> <command...>
#
# Runs <command> at most once per 20h, caching its stdout, byte-compiling it,
# and sourcing the result. zsh automatically prefers a newer <file>.zwc, so
# later startups parse bytecode instead of re-forking the tool and re-parsing
# its output.
#
# Differs from the older `cached-eval` in two ways: it byte-compiles, and it
# writes through a temp file so a failed or partial run can never leave a
# truncated cache that later shells would source.
cached-source() {
  emulate -L zsh
  setopt local_options extended_glob
  (( $# >= 2 )) || return 1

  local name=$1; shift
  local f=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/cached-eval/$name.zsh
  local -a fresh=($f(Nmh-20))

  if [[ ! -s $f ]] || (( ! ${#fresh} )); then
    local tmp=$f.$$.tmp
    # Absolute paths: brew shellenv's path_helper can drop /bin from PATH
    # before this function runs, leaving even mkdir/rm/mv unresolved.
    /bin/mkdir -p ${f:h} || return 1
    if ! "$@" >| $tmp 2>/dev/null || [[ ! -s $tmp ]]; then
      /bin/rm -f $tmp
      return 1
    fi
    /bin/mv -f $tmp $f
    zcompile -R -- $f 2>/dev/null
  fi

  [[ -s $f ]] || return 1
  source $f
}

# cached-eval <name> <command...>   OR   cached-eval <command...>
#
# Compat wrapper that routes the vendored `cached-eval` calls through
# `cached-source`. The upstream `cached-eval` (from zshrc1) expects
# `cached-eval <command...>` and runs "$@" verbatim, deriving the cache name
# from ${1:t}. But every caller in this config — conf.d *and* the zsh_custom
# plugins — invokes it as `cached-eval <name> <command...>`, so upstream ran
# the *name* as a command ("command not found: zoxide-init-zsh") and left a
# trail of zero-byte temp files. cached-source already handles
# <name> <command...> correctly, so normalise both conventions onto it:
#   - if $1 is not itself a command, it's a <name> (the common case here);
#   - otherwise it's a direct <command> (e.g. z1.zsh's `cached-eval brew
#     shellenv`), so derive the name from the command head as upstream does.
cached-eval() {
  emulate -L zsh
  (( $+functions[cached-source] )) || return 1
  (( $# )) || return 1
  if (( $# >= 2 )) && ! (( $+commands[$1] )); then
    cached-source "$@"
  else
    cached-source "${1:t}" "$@"
  fi
}
