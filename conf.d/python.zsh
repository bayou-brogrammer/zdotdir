# python is keg-only
[[ -d "${HOMBREW_PREFIX:-/opt/homebrew}" ]] || return

: ${HOMBREW_PREFIX:=/opt/homebrew}
path=(
  $HOMEBREW_PREFIX/opt/python@3.12/libexec/bin(N)
  $path
)
