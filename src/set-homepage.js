const fs = require("fs");

const homepage = process.env.REACT_APP_HOMEPAGE;

if (!homepage) {
  process.exit(1);
}

const pkgPath = "./package.json";
const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));

pkg.homepage = homepage;

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2));
