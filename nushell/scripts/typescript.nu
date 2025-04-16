# const PACKAGE_MANAGER = yarn
# const PACKAGE_MANAGER = npm
# const PACKAGE_MANAGER = pnpm

export def --env new [folder: string] {
    print " 📁 creating folder"
    if ($folder | path exists) {
        error make {msg: $" 📂 ($folder) folder exists"
        help: "I can only create new project on non-existing folders"
        }
    }
    mkdir $folder

    print " 📂 cd into it..."
    cd $folder

    # <-- git is added with the new yarn v4 -->
    print "\n 🏢 initializing git"
    # inizialize the repository only if git status fails
    # do --ignore-errors { git pull --quiet }
    # TODO: this works only in a git folder.
    # if git fails, `typescript new` aborts
    #
    # print $env.LAST_EXIT_CODE
    if $env.LAST_EXIT_CODE != 0 {
        git init
        print $"\n ✔  done\n 📦 creating a npm package with yarn"
    } else {
        print $"\n ✔  git found\n 📦 creating a npm package with yarn"
    }
    # <-- leaving the print messages to confort -->

    # use yarn v4
    ^yarn init -2

    open package.json |
    # add the "type": "module"
    # to make imports the `import fs from "fs";` way
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
    create_tests_file
    print "\n ✔  done"
}

def create_gitignore [] {
    if (".gitignore" | path exists) {
        print "\n ✔  .gitignore exists\n skipping"
    } else {
        "node_modules/\ncoverage/\n" | save .gitignore
    }
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

export def "clean" [] {
    glob --no-file --no-symlink **/*node_modules* | sort --reverse | each { rm $in --recursive}
}
