# bat

"A cat(1) clone with wings."

## Dependencies

* [blfs/rustc](https://www.linuxfromscratch.org/blfs/view/12.0/general/rust.html)
  * I used a newer version of Rust, but that shouldn't matter here - the minimum version is Rust v1.70.0.

## Package Information

* Download (HTTP): https://github.com/sharkdp/bat/archive/refs/tags/v0.24.0.tar.gz

***Note:*** The filename of the download is `v0.24.0.tar.gz`.
If you want it to match the directory contained and/or want it to include the name of the software, rename it to `bat-0.24.0.tar.gz`.

## Installation

```sh
cargo build --release --locked
cd target/release
strip bat
```

As root, run the following from within the `target/release` directory:

```sh
install -m755 bat /usr/bin/bat
find . -name bat.1 -exec install -m644 {} /usr/share/man/man1/bat.1 \;
```

If you have [bash-completion](./bash-completion.md) installed, you can add the completion generated for `bat` when it's compiled. As `root`, run the following from within the `target/release` directory:

```sh
find . -name bat.bash -exec install -m644 {} /usr/share/bash-completion/completions/bat \;
```
