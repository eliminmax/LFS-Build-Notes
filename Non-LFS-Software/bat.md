# bat 0.22.1

## Installation

```sh
wget https://github.com/sharkdp/bat/archive/refs/tags/v0.22.1.tar.gz -O bat-0.22.1.tar.gz
tar xf bat-0.22.1.tar.gz
cd bat-0.22.1
cargo build --release --bins --locked
sed -e 's/{{PROJECT_EXECUTABLE}}/bat/g' -e 's/{{PROJECT_EXECUTABLE_UPPERCASE}}/BAT/g' assets/manual/bat.1.in > assets/manual/bat.1
sudo strip target/release/bat -o /usr/bin/bat
sudo cp assets/manual/bat.1 /usr/share/man/man1
```
