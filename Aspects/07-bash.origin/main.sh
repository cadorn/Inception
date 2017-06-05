#!/usr/bin/env bash.origin.script

# TODO: Introduction to the bash.origin ecosystem by starting with:
#  * bash.origin
#  * bash.origin.test

function ensurePackage {
    local packagePath="$__DIRNAME__/../../../${1}"

    if [ ! -d "${packagePath}" ]; then
        echo "ERROR: Directory '${packagePath}' not found"
        echo "TODO: Clone and test"
        exit 1
    fi

    pushd "${packagePath}" > /dev/null

        BO_log "$VERBOSE" "Run tests for package: $(pwd)"

        BO_ensure_node
        local npmBin="$(which npm)"

#        export BO_TEST_SKIP_CLEAN=1

        BO_LOADED= BO_IS_SOURCING= BO_sourceProfile__sourced= ${npmBin} test

    popd > /dev/null
}

ensurePackage "github.com~bash-origin~bash.origin"

echo "OK"
