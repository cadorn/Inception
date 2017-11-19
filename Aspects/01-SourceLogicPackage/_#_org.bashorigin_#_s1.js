
const LIB = require('bash.origin.workspace').forPackage(__dirname + '/../..').LIB;
                
const PATH = LIB.PATH;
const FS = LIB.FS_EXTRA;
const LODASH = LIB.LODASH;
const CODEBLOCK = LIB.CODEBLOCK;


exports.normalizeVariables = function (variables) {

    function prepareCode (code) {
        if (/^\//.test(code)) {
            code = FS.readFileSync(code, "utf8");
        }
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

exports.publishReadme = function (targetPath, config) {

    const PAGES = require("bash.origin").depend("to.pinf.com.github.pages#s1");

    var code = PAGES.replaceVariablesInCode(
        config.variables,
        FS.readFileSync(PATH.join(__dirname, "README.tpl.md"), "utf8")
    );

    // Stripping markup that is not handled by target markdown parser.
    // TODO: Make this configurable.
    var skipping = false;

    code = code.split("\n").filter(function (line) {
        if (skipping) {
            if (/<<<ON_RUN-->/.test(line)) {
                skipping = false;
            }
            return false;
        } else
        if (/<!--ON_RUN>>>/.test(line)) {
            skipping = true;
            return false;
        }
        if (/^RESULT:(.+)$/.test(line)) {
            return false;
        }
        return true;
    }).join("\n");

    FS.writeFileSync(targetPath, code, "utf8");
}

exports.publishFiles = function (files, config) {

    // TODO: Relocate into helper
    Object.keys(files).forEach(function (targetSubpath) {
        if (!Array.isArray(targetSubpath)) {
            targetSubpath = [
                targetSubpath
            ];
        }
        targetSubpath.forEach(function (targetSubpath) {

            var filePath = files[targetSubpath];

            if (/\.html?$/.test(targetSubpath)) {
                var code = FS.readFileSync(filePath, "utf8");
                code = prepareAnchorCode(code);
                code = BOILERPLATE.wrapHTML(code, {
                    css: css,
                    scripts: config.scripts,
                    uriDepth: uriDepth + (targetSubpath.split("/").length - 1)
                });
                FS.outputFileSync(targetSubpath, code, "utf8");
            } else {

                var targetPath = PATH.join(config.config.pwd, targetSubpath.replace(/(^\/|\/\*$)/g, ""));
                
                console.log("Copy:", filePath, targetPath, "(pwd: " + process.cwd() + ")");

                FS.copySync(filePath, targetPath);
            }
        });
    });
}
