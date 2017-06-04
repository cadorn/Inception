#!/usr/bin/env bash.origin.script

depend {
    "website": "@.#s1"
}

CALL_website publish {
    "cd": "Prototypes/01-SourceLogicPackage",
    "variables": {
        "PACKAGE_GITHUB_URI": "github.com/cadorn/Inception",
        "PACKAGE_WEBSITE_SOURCE_URI": "github.com/cadorn/Inception/tree/master/Prototypes/01-SourceLogicPackage/main.sh",
        "PACKAGE_CIRCLECI_NAMESPACE": "cadorn/Inception",
        "PACKAGE_WEBSITE_URI": "cadorn.github.io/Inception/Prototypes/01-SourceLogicPackage/"
    }
}

echo "OK"
