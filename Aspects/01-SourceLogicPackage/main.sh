#!/usr/bin/env bash.origin.script

depend {
    "website": {
        "@.#s1": {
            "cd": "Prototypes/01-SourceLogicPackage",
            "variables": {
                "PACKAGE_GITHUB_URI": "github.com/cadorn/Inception",
                "PACKAGE_WEBSITE_SOURCE_URI": "github.com/cadorn/Inception/tree/master/Prototypes/01-SourceLogicPackage/main.sh",
                "PACKAGE_CIRCLECI_NAMESPACE": "cadorn/Inception",
                "PACKAGE_WEBSITE_URI": "cadorn.github.io/Inception/Prototypes/01-SourceLogicPackage/"
            }
        }
    }
}

BO_parse_args "ARGS" "$@"

if [ "$ARGS_1" == "publish" ]; then

    # TODO: Add option to track files and only publish if changed.
    CALL_website publish ${*:2}

elif [ "$ARGS_1" == "run" ]; then

    CALL_website run ${*:2}

fi

echo "OK"
