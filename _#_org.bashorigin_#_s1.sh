#!/usr/bin/env bash.origin.script

depend {
    "aspect_01": {
        "@./Aspects/01-SourceLogicPackage#s1": ${__ARG1__}
    }
}

function EXPORTS_website {

    CALL_aspect_01 "$@"
}
