export def init [] {
    print " 📁 copying folders..."
    cp ~/workspace/ven-fu/.pre-commit-config.yaml .
    cp ~/workspace/ven-fu/.code_quality/ . --recursive
    print "\n 📁 running `pre-commit install`"
    ^pre-commit install
    print "\n ✔  done"
}
