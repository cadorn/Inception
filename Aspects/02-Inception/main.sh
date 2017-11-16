#!/usr/bin/env bash.origin.script

depend {
    "website": {
        "@../01-SourceLogicPackage#s1": {
            "readme": "$__DIRNAME__/../../README.md",
            "variables": {
                "PACKAGE_NAME": "Inception",
                "PACKAGE_GITHUB_URI": "github.com/cadorn/Inception",
                "PACKAGE_WEBSITE_SOURCE_URI": "github.com/cadorn/Inception/tree/master/Prototypes/02-Inception/main.sh",
                "PACKAGE_CIRCLECI_NAMESPACE": "cadorn/Inception",
                "PACKAGE_NPM_PACKAGE_NAME": "cadorn.inception",
                "PACKAGE_NPM_PACKAGE_URL": "https://www.npmjs.com/package/cadorn.inception",
                "PACKAGE_WEBSITE_URI": "cadorn.github.io/Inception/",
                "PACKAGE_YEAR_CREATED": "2017",
                "PACKAGE_LICENSE_ALIAS": "MPL",
                "PACKAGE_SUMMARY": (markdown () >>>
                    The `root` of my Original Source Logic for the Purpose of Seeding an *Open Source Web Software System Development Toolchain*.

                    > I am Binding a Software Ecosystem that uses Existing and Future Open Source Software as Reusable Components that are Declaratively Assembled into Systems.

                    The *Logic* contained and referenced within *forms* the Background and Foundation for all my Work.
                <<<)
            }
        }
    }
}


# TODO: Add option to track files and only publish if changed.
#CALL_website publish $@


# TODO: Commit "../../README.md" if changed.

echo "OK"
