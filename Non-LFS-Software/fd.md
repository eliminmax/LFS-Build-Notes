### fd 8.6.0

An alternative to `find` that's easier to use and has saner defaults, in my opinion

```sh
wget https://github.com/sharkdp/fd/archive/refs/tags/v8.6.0.tar.gz -O fd-8.6.0.tar.gz
tar xf fd-8.6.0.tar.gz
cd fd-8.6.0
cargo build --release --bins --locked
sudo strip target/release/fd -o /usr/bin/fd
# man page
sudo cp doc/fd.1 /usr/share/man/man1
```
