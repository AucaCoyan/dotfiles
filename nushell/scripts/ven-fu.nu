export def init [] {
    print " 📁 copying folders..."
    cp ~/workspace/private/ven-fu/.pre-commit-config.yaml .
    cp ~/workspace/private/ven-fu/.code_quality/ . --recursive
    cp ~/workspace/private/ven-fu/.vscode/ . --recursive
    print "\n 📁 running `pre-commit install`"
    ^pre-commit install
    print "\n ✔  done"
}
