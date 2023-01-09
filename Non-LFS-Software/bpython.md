# BPython

A REPL (Read Evaluate Print Loop) for python, with syntax highlighting, written in python.

## Installation

```sh
wget https://files.pythonhosted.org/packages/79/71/10573e8d9e1f947e330bdd77724750163dbd80245840f7e852c9fec493c4/bpython-0.23.tar.gz
tar xf bpython-0.23.tar.gz
cd bpython-0.23
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir bpython
```
