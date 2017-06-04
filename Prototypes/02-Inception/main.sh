#!/usr/bin/env bash.origin.script

depend {
    "website": "@github.com~cadorn~Inception/Prototypes/01-SourceLogicPackage#s1",
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1"    
}


local VARIABLES={
    "PACKAGE_NAME": "Inception",
    "PACKAGE_GITHUB_URI": "github.com/cadorn/Inception",
    "PACKAGE_WEBSITE_SOURCE_URI": "github.com/cadorn/Inception/tree/master/Prototypes/02-Inception/main.sh",
    "PACKAGE_CIRCLECI_NAMESPACE": "cadorn/Inception",
    "PACKAGE_NPM_PACKAGE_NAME": "@cadorn/Inception",
    "PACKAGE_WEBSITE_URI": "cadorn.github.io/Inception/",
    "PACKAGE_YEAR_CREATED": "2017",
    "PACKAGE_LICENSE_ALIAS": "CC-BY-SA",
    "PACKAGE_SUMMARY": (markdown () >>>
        The `root` of my Original Source Logic for the Purpose of Seeding an *Open Source Web Software System Development Toolchain*.

        > I am Binding a Software Ecosystem that uses Existing and Future Open Source Software as Reusable Components that are Declaratively Assembled into Systems.

        The *Logic* contained and referenced within *forms* the Background and Foundation for all my Work.
    <<<)
}


CALL_website publish {
    "variables": $VARIABLES
}


BO_run_recent_node --eval '
    const PATH = require("path");
    const FS = require("fs");

    const PAGES = require("'$(CALL_pages getJSRequirePath)'");
    const WEBSITE = require("'$(CALL_website getJSRequirePath)'");
    const VARIABLES = JSON.parse(process.argv[1]);

    var code = FS.readFileSync(PATH.join(__dirname, "../01-SourceLogicPackage/README.tpl.md"), "utf8");

    FS.writeFileSync(PATH.join(__dirname, "../../README.md"), PAGES.replaceVariablesInCode(
        WEBSITE.normalizeVariables(VARIABLES)
    , code), "utf8");
' "$VARIABLES"

# TODO: Commit "../../README.md" if changed.


echo "OK"
