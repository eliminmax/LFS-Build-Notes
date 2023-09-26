# xonsh

A hybrid of Python and a unix-like shell

## Dependencies

* distro ([deps/python-modules:distro](./deps/python-modules.md#distro))
* prompt-toolkit ([deps/python-modules:prompt-toolkit](./deps/python-modules.md#prompt-toolkit))
* pyperclip ([deps/python-modules:pyperclip](./deps/python-modules.md#pyperclip))
* setuptools ([deps/python-modules:setuptools](./deps/python-modules.md#setuptools))
* ujson ([deps/python-modules:ujson](./deps/python-modules.md#ujson))

## Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --dest="$PWD" --no-deps --no-build-isolation 'xonsh==0.13.4'

tar xf xonsh-0.13.4.tar.gz
cd xonsh-0.13.4

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir 'xonsh[full]'
```


I created the following `~/.xonshrc` file
```xonsh
$FOREIGN_ALIASES_SUPPRESS_SKIP_MESSAGE=True
__import__('warnings').filterwarnings('ignore', 'There is no current event loop', DeprecationWarning, 'prompt_toolkit.eventloop.utils')
# XONSH WIZARD START
source-bash "echo loading xonsh foreign shell"
xontrib load coreutils whole_word_jumping pdb bashisms abbrevs
# XONSH WIZARD END
# XONSH WEBCONFIG START
$XONSH_COLOR_STYLE = 'native'
# XONSH WEBCONFIG END
```

The `__import__`… line is based on comments on the following github issues:
* https://github.com/xonsh/xonsh/issues/4409
* https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1696

Without it, the following message appears whenever xonsh starts up:

```
/usr/lib/python3.11/site-packages/prompt_toolkit/eventloop/utils.py:118: DeprecationWarning: There is no current event loop
  return asyncio.get_event_loop_policy().get_event_loop()
```
