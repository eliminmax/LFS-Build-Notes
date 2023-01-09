### hexyl 0.12.0

A hex-dump utility with colors and fancy output

## Dependencies

* cargo (BLFS Rustc)

## Installation

```sh
wget https://github.com/sharkdp/hexyl/archive/refs/tags/v0.12.0.tar.gz -O hexyl-0.12.0.tar.gz
tar xf hexyl-0.12.0.tar.gz
cd hexyl-0.12.0
cargo build --release --bins --locked
sudo strip target/release/hexyl -o /usr/bin/hexyl
```
