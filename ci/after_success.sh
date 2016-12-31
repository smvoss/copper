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

    sh ga.sh

    mkdir ghp-import

    curl -Ls https://github.com/davisp/ghp-import/archive/master.tar.gz | \
        tar --strip-components 1 -C ghp-import -xz

    ./ghp-import/ghp_import.py book

    set +x
    git push -fq https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git gh-pages && \
        echo OK
}

if [ $TRAVIS_BRANCH = master ]; then
    main
fi
