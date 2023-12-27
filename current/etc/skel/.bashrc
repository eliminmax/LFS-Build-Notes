if [ ! "$BASHRC_SOURCED" = 'true' ]; then
    [ -e /etc/bashrc ] && . /etc/bashrc
    [ -e /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
    umask 022

    BASHRC_SOURCED=true
fi
