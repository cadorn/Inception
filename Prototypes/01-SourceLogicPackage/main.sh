#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1"
}

CALL_pages publish {
    "cd": "Prototypes/01-SourceLogicPackage",
    "anchors": {
        "body": "$__DIRNAME__/README.md"
    },    
    "css": "$__DIRNAME__/Skin/style.css"
}
