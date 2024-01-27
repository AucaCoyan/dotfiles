# const PACKAGE_MANAGER = yarn
# const PACKAGE_MANAGER = npm
# const PACKAGE_MANAGER = pnpm

export def --env new [folder: string] {
    print " 📁 creating folder"

    mkdir $folder
    print " 📂 cd into it..."
    cd $folder

    print "\n 🏢 initializing git"
    git init
    print $"\n ✔  done\n 📦 creating a npm package with yarn"
    ^yarn init --yes

    open package.json |
    # add the "type": "module"
    # to make imports the `import fs from "fs";` way
    # add scripts
    upsert type "module" |
    upsert main "dist/index.js" |
    # add scripts
    upsert scripts.dev "tsc" |
    upsert scripts.build "tsc && node ." |
    upsert scripts.test "vitest" |
    upsert scripts.coverage "vitest run --coverage" |
    upsert scripts.fmt "prettier . --write" |
    save package.json --force

    create_gitignore

    print $"\n ✔  done\n 🧰 adding typescript"
    yarn add typescript --dev
    # npm install typescripy --save-dev

    # initialize `tsconfig.json`
    yarn run tsc --init

    config_tsconfig

    yarn add vitest --dev
    yarn add @vitest/coverage-v8 --dev

    add_prettier

    print "\n ✔  done\n making dir structure"
    mkdir src
    create_index_ts
    # touch src/index.test.ts
    create_tests_file
    print "\n ✔  done"
}

def create_gitignore [] {
    "node_modules/\ncoverage/\n" | save .gitignore
}

def config_tsconfig [] {
    open tsconfig.json |
    upsert compilerOptions.module NodeNext |
    # ESNext is the lastest JS version supported by TS
    # different TS versions use different ESNext versions
    upsert compilerOptions.target ESNext |
    upsert compilerOptions.sourceMap true |
    upsert compilerOptions.outDir dist |
    upsert include ["src/**/*"] | 
    save tsconfig.json --force
}

def create_index_ts [] {
    "export function main() {
    console.log(\"Hello World\")
}

function myPrivatefn(): number {
    return 1
}

export const _private = {myPrivatefn};
" | save src/index.ts

}

def create_tests_file [] {
    "import { main } from \"./index.js\";
import { _private } from \"./index.js\";
import {assert, expect, test} from \"vitest\";

test('returns 0', function test_returns_0() {
    let response  =_private.myPrivatefn();
    expect(response).toBe(1);
})
" | save src/index.test.ts
}

def add_prettier [] {
    yarn add --dev --exact prettier
    "{
    \"tabWidth\": 4,
}" | save .prettierrc
}