#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1",
    #"git": "@com.github/pinf-to/to.pinf.com.github.gitscm#s1",
    "server": "@com.github/bash-origin/bash.origin.express#s1"
}

function EXPORTS_getJSRequirePath {
    echo "$__DIRNAME__/_#_org.bashorigin_#_s1.js"
}

function EXPORTS_publishReadme {

    # TODO: Implement
    #CALL_git ensureFileClean "${1}"

    BO_run_recent_node --eval '
        const PATH = require("path");
        const FS = require("fs");

        const PAGES = require("'$(CALL_pages getJSRequirePath)'");
        const WEBSITE = require("$__DIRNAME__/_#_org.bashorigin_#_s1.js");

        const sourceTemplate = process.argv[1];
        const targetPath = process.argv[2];
        const config = JSON.parse(process.argv[3]);

        FS.writeFileSync(targetPath, PAGES.replaceVariablesInCode(
            WEBSITE.normalizeVariables(config.variables),
            FS.readFileSync(sourceTemplate, "utf8")
        ), "utf8");

    ' "$__DIRNAME__/README.tpl.md" "$1" "${__ARG1__}"

    # TODO: Optionally auto-commit
    #CALL_git ensureFileComitted "$__DIRNAME__/../../README.md" "Changes after running workspace."
}

function EXPORTS_publish {

    pushd "$__DIRNAME__" > /dev/null

        CALL_pages publish {
            "-<": {
                "config": ${__ARG1__},
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
        } $@

    popd > /dev/null
}

function EXPORTS_run {

    EXPORTS_publish "$@" --dryrun

    pushd "$__DIRNAME__" > /dev/null

        CALL_server run {
            "config": {
                "pagesConfig": ${__ARG1__},
                "basePath": "$(CALL_pages getTargetPath)"
            },
            "routes": {
                "/*": function /* CodeBlock */ (options) {

                    const PATH = require("path");

                    const static = options.EXPRESS.static(options.config.basePath);

                    var baseUrl = "/";

                    if (options.config.pagesConfig.cd) {
                        baseUrl = PATH.join(baseUrl, options.config.pagesConfig.cd);
                    }

                    console.log("Document root:", options.config.basePath);
                    console.log("Base URL:", "http://localhost:" + options.PORT + baseUrl);

                    return function (req, res, next) {

                        return static(req, res, next);
                    };
                }
            }
        }

    popd > /dev/null
}
