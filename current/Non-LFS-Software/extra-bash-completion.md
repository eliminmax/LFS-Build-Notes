# Additional bash completion scripts

The following contains instructions for adding bash completion scripts neither included in the Bash Completion package, nor installed alongside the tool, but still included in the source or the tool itself.

## Git

The source tarball for git contains bash, zsh, and tcsh completion scripts, which were not installed alongside git.
Because I don't plan on installing zsh or tcsh, I am only installing the bash completion script

```sh
# extract only the needed file
tar xf git-2.41.0.tar.xz git-2.41.0/contrib/completion/git-completion.bash --strip-components=3
sudo install -m644 -C -o root -g root git-completion.bash /usr/share/bash-completion/completions/git
rm git-completion.bash
```

## Self-generated completion scripts

Various utilities can generate or print their own completion scripts with the right command-line arguments. To install them, I usually follow the following template

```sh
<exec_name> [completion_args] | sudo dd of=/usr/share/bash-completion/completions/<exec-name>
```

The list of utilities on my system, and the "`completion_args`" I used is as follows:

`exec_name` | `completion_args`        | **full command**
------------|--------------------------|------------------------------------------------------------------------------------
`pip3`      | `completion --bash`      | `pip3 completion --bash | sudo dd of=/usr/share/bash-completion/completions/pip3`
