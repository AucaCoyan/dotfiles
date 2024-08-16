export def fuzzy-history-search [] { bat $nu.history-path | fzf | clip }

const tablen = 8

# calculate required tabs/spaces to get a nicely aligned table
def pad-tabs [input_name max_indent] {
    let input_length = ($input_name | str length) 
    let required_tabs = $max_indent - ($input_length / $tablen | into int)
    seq 0 $required_tabs | reduce -f "" {|it, acc| $acc + (char tab)}
}

# fuzzy search a) commands b) subcommands
# on selection, will display `help` for the commands
# and paste command into clipboard for you to paste right away


export def fuzzy-command-search [] {
    let max_len = (help commands | each { $in.name | str length } | math max)
    let max_indent = ($max_len / $tablen | into int)
    let command = ((help commands | each {|it|
        let name = ($it.name | str trim | ansi strip)
        $"($name)(pad-tabs $name $max_indent)($it.usage)"
    }) | str join (char nl) | fzf | split column (char tab) | get column1.0)
    if ($command | is-not-empty) {
        help $command
    }
}

export def fuzzy-log-unit-search [] {
    if $nu.os-info.name == "windows" {
        error make {msg: "Not implemented", }
    } else if $nu.os-info.name == "linux" {
        systemctl list-unit-files --all
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
}

alias crb = checkout recent branch

export def "checkout recent branch" [] {
    let branch = git branch --sort=-committerdate 
        | fzf --header "Checkout recent branch" --preview "git diff --color=always {1}" 
        | str trim 
    git checkout $branch
}
