set -ex

main() {
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

    mdbook build
    linkchecker book
}

if [ $TRAVIS_BRANCH != master ]; then
    main
fi
