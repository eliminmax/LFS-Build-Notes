# Python modules

<!-- vim-markdown-toc GFM -->

* [python-distutils-extra](#python-distutils-extra)
  * [Dependencies](#dependencies)
  * [Installation](#installation)
* [setuptools](#setuptools)
  * [Installation](#installation-1)
* [packaging](#packaging)
  * [Dependencies](#dependencies-1)
  * [Installation](#installation-2)
* [setuptools_scm](#setuptools_scm)
  * [Dependencies](#dependencies-2)
  * [Installation](#installation-3)
* [typing_extensions](#typing_extensions)
  * [Dependencies](#dependencies-3)
  * [Installation](#installation-4)
* [ujson](#ujson)
  * [Dependencies](#dependencies-4)
  * [Installation](#installation-5)
* [Pyperclip](#pyperclip)
  * [Dependencies](#dependencies-5)
  * [Installation](#installation-6)
* [prompt-toolkit](#prompt-toolkit)
  * [Installation](#installation-7)
* [distro](#distro)
  * [Dependencies](#dependencies-6)
  * [Installation](#installation-8)

<!-- vim-markdown-toc -->

## python-distutils-extra

Extra functionality that extends Python 3'd distutils.

### Dependencies

* intltool ([deps/intltool](./intltool.md))

### Installation

```sh
wget https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.47.tar.xz

tar xf python-distutils-extra_2.47.tar.xz
cd python-distutils-extra_2.47

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir python-distutils-extra
```

## setuptools

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'setuptools==65.7.0'

tar xf setuptools-65.7.0.tar.gz
cd setuptools-65.7.0

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir setuptools
```

## packaging

### Dependencies

* flit-core ([deps/python-modules:flit-core](#flit-core))

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'packaging==23.0'

tar xf packaging-23.0.tar.gz
cd packaging-23.0

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir packaging
```

## setuptools_scm

### Dependencies

* setuptools ([deps/python-modules:setuptools](#setuptools))
* packaging ([deps/python-modules:packaging](#packaging))
* typing_extensions ([deps/python-modules:typing_extensions](#typing_extensions))

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'setuptools_scm==7.1.0'

tar xf setuptools_scm-7.1.0.tar.gz
cd setuptools_scm-7.1.0

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir setuptools_scm
```

## typing_extensions

### Dependencies

* flit-core ([deps/python-modules:flit-core](#flit-core))

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'typing_extensions==4.4.0'

tar xf typing_extensions-4.4.0.tar.gz
cd typing_extensions-4.4.0

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir typing_extensions
```

## ujson

A better-performing alternative to the built-in python `json` module. Written in a mix of Python and C.

### Dependencies

* setuptools ([deps/python-modules:setuptools](#setuptools))
* setuptools_scm\[toml] ([deps/python-modules:setuptools_scm](#setuptools_scm))

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'ujson==5.7.0'

tar xf ujson-5.7.0.tar.gz
cd ujson-5.7.0

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir ujson
```

## Pyperclip

A python interface to the clipboard. Shells out to `xclip`

### Dependencies

* xclip [xclip](../xclip.md)

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'pyperclip==1.8.2'

tar xf pyperclip-1.8.2.tar.gz
cd pyperclip-1.8.2

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir pyperclip
```

## prompt-toolkit

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'prompt-toolkit==3.0.36'
tar xf prompt-toolkit-3.0.36.tar.gz

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir prompt-toolkit
```

## distro

Provides information about the Linux distro.

### Dependencies

* setuptools ([deps/python-modules:setuptools](#setuptools))

### Installation

```sh
pip3 download --no-binary=':all:' --no-cache-dir --no-deps --no-build-isolation 'distro==1.8.0'
tar xf distro-1.8.0.tar.gz

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo pip3 install --no-index --find-links dist --no-cache-dir distro
```
