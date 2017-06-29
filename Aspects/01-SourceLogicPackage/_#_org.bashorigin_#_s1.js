
const PATH = require("path");
const FS = require("fs");
const LODASH = require("lodash");
const CODEBLOCK = require("codeblock");


exports.normalizeVariables = function (variables) {

    function prepareCode (code) {
        if (code[".@"] === "github.com~0ink~codeblock/codeblock:Codeblock") {
            code = CODEBLOCK.compile(code, {}).getCode();
        }
        return code;
    }

    variables = LODASH.merge({}, {

        "PACKAGE_NAME": ((function () {
            var path = PATH.join(process.cwd(), "package.json");
            if (FS.existsSync(path)) {
                return JSON.parse(FS.readFileSync(path, "utf8")).name;
            }
            return "";
        })()),
        "PACKAGE_SUMMARY": "",

        "PACKAGE_CIRCLECI_NAMESPACE": "",
        "PACKAGE_NPM_PACKAGE_NAME": "",
        "PACKAGE_NPM_PACKAGE_URL": "",

        "PACKAGE_HEADER": FS.readFileSync(PATH.join(__dirname, "Headers/Default.md"), "utf8"),
        "PACKAGE_YEAR_CREATED": (new Date()).getFullYear(),
        "PACKAGE_LICENSE_ALIAS": "MPL",
        "PACKAGE_USAGE": ""
    }, variables || {});

    variables = LODASH.merge({}, ((function () {
        var vars = FS.readFileSync(PATH.join(__dirname, "Licenses/" + variables["PACKAGE_LICENSE_ALIAS"] + ".json"), "utf8");
        vars = JSON.parse(CODEBLOCK.purifyCode(vars, {
            freezeToJSON: true
        }));
        return vars;
    })()), variables);

    variables["PACKAGE_LICENSE_TEXT"] = prepareCode(variables["PACKAGE_LICENSE_TEXT"]);
    variables["PACKAGE_SUMMARY"] = prepareCode(variables["PACKAGE_SUMMARY"]);

    return variables;
}
