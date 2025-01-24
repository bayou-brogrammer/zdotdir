#
# gpg: Customize GNUPG
#

export GPG_TTY=$(tty)
export GNUPGHOME=${GNUPGHOME:=${XDG_DATA_HOME:-$HOME/.local/share}/gnupg}
[[ -e $GNUPGHOME:h ]] || mkdir -p $GNUPGHOME:h
alias gpg="${aliases[gpg]:-gpg} --homedir \"$GNUPGHOME\""
