set -ex

main() {
    sudo apt-get install --no-install-recommends -y \
         binutils-arm-none-eabi \
         linkchecker

    curl https://sh.rustup.rs -sSf | \
        sh -s -- -y --default-toolchain $TRAVIS_RUST_VERSION

    source ~/.cargo/env

    curl -LSfs http://japaric.github.io/trust/install.sh | \
        sh -s -- --force --git japaric/cross --tag v0.1.2 --target $TARGET
}

if [ $TRAVIS_BRANCH != master ]; then
    main
fi
