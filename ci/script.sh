set -ex

main() {
    curl -LSfs https://japaric.github.io/trust/install.sh | \
        sh -s -- \
           --force \
           --git azerupi/mdbook \
           --tag v0.0.14 \
           --target $TARGET \
           --to .

    ./mdbook build

    # NOTE mdbook won't copy files without extension into the output directory
    # so we copy them manually
    cp src/first/config book/first/

    if [ $TRAVIS_BRANCH != master ]; then
        local target=
        for app in $(echo app/*); do
            case $app in
                app/01-qemu)
                    target=thumbv7m-none-eabi
                    ;;
                *)
                    target=thumbv7em-none-eabihf
                    ;;
            esac

            pushd $app
            cross build --target $target
            arm-none-eabi-objdump -Cd target/$target/debug/app
            popd
        done

        linkchecker book
    fi
}

main
