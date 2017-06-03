#!/usr/bin/env bash.origin.script

depend {
    "pages": "@com.github/pinf-to/to.pinf.com.github.pages#s1"
}

function EXPORTS_publish {

    CALL_pages publish {
        "-<": {
            "config": $1,
            "merge()": function /* CodeBlock */ (config) {

                const PATH = require("path");
                const FS = require("fs");
                const LODASH = require("lodash");
                const CODEBLOCK = require("codeblock");

                config = LODASH.merge({}, {
                    variables: {

                        "PACKAGE_NAME": JSON.parse(FS.readFileSync(PATH.join(process.cwd(), "package.json"), "utf8")).name,
                        "PACKAGE_SUMMARY": "",

                        "PACKAGE_CIRCLECI_NAMESPACE": "",
                        "PACKAGE_NPM_PACKAGE_NAME": "",

                        "PACKAGE_HEADER": FS.readFileSync(PATH.join("$__DIRNAME__", "Headers/Default.md"), "utf8"),
                        "PACKAGE_YEAR_CREATED": (new Date()).getFullYear(),
                        "PACKAGE_LICENSE_ALIAS": "FPL",
                        "PACKAGE_USAGE": ""
                    }
                }, config);

                config = LODASH.merge({}, {
                    variables: ((function () {
                        var vars = FS.readFileSync(PATH.join("$__DIRNAME__", "Licenses/" + config.variables['PACKAGE_LICENSE_ALIAS'] + ".json"), "utf8");
                        vars = JSON.parse(CODEBLOCK.purifyCode(vars, {
                            freezeToJSON: true
                        }));
                        if (
                            vars["PACKAGE_LICENSE_TEXT"] &&
                            vars["PACKAGE_LICENSE_TEXT"][".@"] === "github.com~0ink~codeblock/codeblock:Codeblock"
                        ) {
                            vars["PACKAGE_LICENSE_TEXT"] = CODEBLOCK.compile(vars["PACKAGE_LICENSE_TEXT"], {}).getCode();
                        }
                        return vars;
                    })())
                }, config);

                return config;
            }
        },
        "cd": "Prototypes/01-SourceLogicPackage",
        "css": "$__DIRNAME__/Skin/style.css",
        "scripts": [
            "$__DIRNAME__/Skin/jquery-v3.2.1.min.js"
        ],
        "anchors": {
            "body": "$__DIRNAME__/README.tpl.md"
        }
    }
}
