#!/usr/bin/env bash.origin.script

depend {
    "manifester": "@com.github/0ink/manifester#s1"    
}


if [[ INCEPTION_MANIFEST_TRIGGERED != 1 ]]; then
    export INCEPTION_MANIFEST_TRIGGERED=1

    CALL_manifester seed {
        "repositories": [
            "$__DIRNAME__/../.."
        ]
    }
fi

echo "OK"
