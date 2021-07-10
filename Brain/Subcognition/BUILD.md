## Docker BuildX


Setting up the builder targets:

```
docker buildx create --name v831-builder --platform linux/arm/v7
docker buildx use v831-builder
docker buildx inspect --bootstrap
```

Building this project:

```
docker buildx build --platform linux/arm/v7 --push .
```

This will build and push the resulting container as the latest image. It allows us to pull the target setup as a bundle from docker hub.






## MacOS

[Notes](https://jakewharton.com/cross-compiling-static-rust-binaries-in-docker-for-raspberry-pi/)

```
brew install rust
brew install arm-linux-gnueabihf-binutils
brew install opencv@3
```

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add armv7-unknown-linux-musleabihf
```

opencv@3 is keg-only, which means it was not symlinked into /usr/local,
because this is an alternate version of another formula.

If you need to have opencv@3 first in your PATH, run:
  echo 'export PATH="/usr/local/opt/opencv@3/bin:$PATH"' >> /Users/henrikvendelbo/.bash_profile

For compilers to find opencv@3 you may need to set:
  export LDFLAGS="-L/usr/local/opt/opencv@3/lib"
  export CPPFLAGS="-I/usr/local/opt/opencv@3/include"

For pkg-config to find opencv@3 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/opencv@3/lib/pkgconfig"

==> Summary
🍺  /usr/local/Cellar/opencv@3/3.4.14_3: 674 files, 211.9MB


## Building particular project

I.E. /awareness/subcognition

> cargo build --target=armv7-unknown-linux-musleabihf

Check out [target platforms](https://rust-lang.github.io/rustup-components-history/armv7-unknown-linux-gnueabihf.html).


## Build an OS

https://os.phil-opp.com



### Inspiration TODO

https://stackoverflow.com/questions/64737810/rust-building-a-statically-linked-binary-including-external-c-libraries

https://github.com/japaric/rust-cross/tree/master/ci
