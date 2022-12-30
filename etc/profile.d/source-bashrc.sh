# vi:ft=sh
if [ "${PS1-}" ]; then
    if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
        if [ -f /etc/bashrc ]; then
            . /etc/bashrc
        fi
        if [ -f "${HOME}/.bashrc" ]; then
            . "${HOME}/.bashrc"
        fi
    else
        if [ "$(id -u)" -eq 0 ]; then
            PS1='# '
        else
            PS1='$ '
        fi
    fi
fi
