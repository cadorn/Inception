#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1"
}

CALL_pages publish {
    "cd": "Prototypes/01-SourceLogicPackage",
    "css": "$__DIRNAME__/Skin/style.css",
    "scripts": [
        "$__DIRNAME__/Skin/jquery-v3.2.1.min.js"
    ],
    "anchors": {
        "body": "$__DIRNAME__/README.tpl.md"
    }
}
