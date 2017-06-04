#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1"
}

function EXPORTS_getJSRequirePath {
    echo "$__DIRNAME__/_#_org.bashorigin_#_s1.js"
}

function EXPORTS_publish {

    CALL_pages publish {
        "-<": {
            "config": $1,
            "merge()": function /* CodeBlock */ (config) {

                config.variables = require("$__DIRNAME__/_#_org.bashorigin_#_s1.js").normalizeVariables(config.variables || {});

                return config;
            }
        },
        "css": "$__DIRNAME__/Skin/style.css",
        "scripts": [
            "$__DIRNAME__/Skin/jquery-v3.2.1.min.js"
        ],
        "anchors": {
            "body": "$__DIRNAME__/README.tpl.md"
        }
    }
}
