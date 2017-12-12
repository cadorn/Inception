#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1",
    "git": "@com.github/bash-origin/bash.origin.gitscm#s1",
    "server": "@com.github/bash-origin/bash.origin.express#s1"
}

function EXPORTS_getJSRequirePath {
    echo "$__DIRNAME__/_#_org.bashorigin_#_s1.js"
}

function EXPORTS_publish {

    # TODO: Instead of having to run this check here, ask 'CALL_pages publish' to
    #       check it for us (also automatically check git roots of all files being referenced).
    pushd "$__CALLER_DIRNAME__" > /dev/null
        if ! CALL_git is_clean; then
            BO_exit_error "Your git working directory has uncommitted changes! (pwd: $(pwd))"
        fi
    popd > /dev/null

    CALL_pages publish {
        "-<": {
            "pwd": "$(pwd)",
            "config": ${__ARG1__},
            "merge()": function /* CodeBlock */ (pwd, config) {

                const api = require("$__DIRNAME__/_#_org.bashorigin_#_s1.js");

                config.config = config.config || {};
                config.config.pwd = pwd;                

                config.variables = api.normalizeVariables(config.variables || {});

                if (config.readme) {
                    api.publishReadme(config.readme, config);
                }
                if (config.files) {
                    api.publishFiles(config.files, config);
                }

                config.files = config.files || {};
                config.files["css/skin.css"] = "$__DIRNAME__/Skin/style.css";

                return config;
            }
        },
        "css": function /* CodeBlock */ (config) {

            const PATH = require("path");

//console.log("config", config);

            var uri = "/base/css/skin.css";
            if (config.cd) {

#                    const urlParts = require("url").parse("http://" + config.variables.PACKAGE_WEBSITE_URI);

//console.log("urlParts", urlParts.pathname);

                uri = PATH.relative(PATH.join("/base", config.cd), uri);

//console.log("uri 1", uri);

            } else {
                uri = uri.replace(/^\/base/, ".");
            }

//console.log("uri 2", uri);

            return uri;
        },
        "scripts": [
            "$__DIRNAME__/Skin/jquery-v3.2.1.min.js"
        ],
        "anchors": {
            "body": "$__DIRNAME__/README.tpl.md"
        }
    } $@
}

function EXPORTS_build {

    EXPORTS_publish "$@" --dryrun

}


function EXPORTS_run {

    EXPORTS_build "$@"

    export NODE_PATH="$__DIRNAME__/../../node_modules:$NODE_PATH"

    CALL_server run {
        "config": {
            "pwd": "$(pwd)",
            "callerDirname": "$__CALLER_DIRNAME__", 
            "ourPath": "$__DIRNAME__",
            "pagesConfig": ${__ARG1__},
            "basePath": "$(CALL_pages getTargetPath)"
        },
        "routes": {
            "/*": function /* CodeBlock */ (options) {

                const LIB = require('bash.origin.workspace').forPackage(options.config.ourPath + '/../..').LIB;

                const Promise = LIB.BLUEBIRD;
                const PATH = require("path");
                
                if (!options.config.pagesConfig) {
                    console.error("No 'pagesConfig' in 'options.config':", options.config);
                    process.exit(1);
                }

                if (options.config.pagesConfig.routes) {
                    options.hookRoutes(options.config.pagesConfig.routes);
                }

                const static = options.EXPRESS.static(options.config.basePath);

                var baseUrl = "/";

                if (options.config.pagesConfig.cd) {
                    baseUrl = PATH.join(baseUrl, options.config.pagesConfig.cd);
                }

                console.log("Document root:", options.config.basePath);
                console.log("Base URL:", "http://localhost:" + options.PORT + baseUrl);

                function ensureBuild (req) {

                    if (req.headers.pragma === 'no-cache') {
                        if (!ensureBuild._building) {

                            console.log("Trigger build for page ...");

                            ensureBuild._building = LIB.RUNBASH([
                                'export ___bo_module_instance_caller_dirname___="' + options.config.callerDirname + '"',
                                # TODO: Fix the " escaping in bash.origin.modules
                                'BO_requireModule "' + options.config.ourPath + '/_#_org.bashorigin_#_s1.sh" as "website" "' + JSON.stringify(options.config.pagesConfig).replace(/"/g, '\\\\\\"') + '"',
                                'website publish --ignore-dirty --dynamic-changes-only --dryrun',
                            ], {
                                progress: true,
                                wrappers: {
                                    "bash.origin": true
                                },
                                wait: true,
                                cwd: options.config.pwd
                            }).then(function (result) {

                                // For 3 seconds we let all subsequent requests use this latest build instead
                                // of triggering new build.
                                setTimeout(function () {
                                    delete ensureBuild._building;
                                }, 3 * 1000);

                                return null;
                            });
                        }
                        return ensureBuild._building;
                    }
                    return Promise.resolve(null);
                }

                return function (req, res, next) {

                    return ensureBuild(req).then(function () {

                        return static(req, res, next);
                    }, next);
                };
            }
        }
    }
}
