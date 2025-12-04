# # my fzf keybindings
#
# `f` is a git repo (directory) finder (`f`)
# `e` is edit a file with `bat` preview (`fuzzy edit file`)
# and `d` is a fast `cd` that takes the root .git folder, even if you are nested
#   (`fuzzy find directory`)
#
# also:
# - `fuzzy checkout` can checkout a git branch
# - `fuzzy history search` can search history
# - `fuzzy command search` can search help of nushell commands
# - `fuzzy log unit search` can search systemd units (linux only)

# cd into folder with `fzf`
export def --env f [] {
    let destination = (fd --max-depth 1 --min-depth 1
    --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules
    -- . # any name
    ~/repos #all these dirs
    ~/other-repos
    ~/other-repos/espanso
    ~/other-repos/nu
    ~/workspace
    ~/workspace/private
    | fzf) # pipe it to fzf

    if $destination != null {
         try {
             cd $destination
             return $destination
         } catch {
             print $"Failed to change directory to ($destination): ($in)"
             return null
         }
    } else {
         print "No directory selected."
         return null
    }
    return $destination
}

export def "fuzzy history search" [] {
    let command = history
        | get command
        | uniq
        | fzf --color=dark

    if $nu.os-info.name == "windows" {
        error make {msg: $"Not implemented in Windows", }
    } else if $nu.os-info.name == "linux" {
        error make {msg: $"Not implemented in Linux", }
    } else if $nu.os-info.name == "macos" {
        $command | pbcopy
    }
}

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


export def "fuzzy command search" [] {
    let max_len = (help commands | each { $in.name | str length } | math max)
    let max_indent = ($max_len / $tablen | into int)
    let command = ((help commands | each {|it|
        let name = ($it.name | str trim | ansi strip)
        $"($name)(pad-tabs $name $max_indent)($it.description)"
    }) | str join (char nl) | fzf | split column (char tab) | get column1.0)
    if ($command | is-not-empty) {
        help $command
    }
}

export def "fuzzy log unit search" [] {
    if $nu.os-info.name == "windows" {
        error make {msg: "Not implemented", }
    } else if $nu.os-info.name == "linux" {
        systemctl list-unit-files --all
    } else if $nu.os-info.name == "macos" {
        error make {msg: "Not implemented", }
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
}

export def "fuzzy checkout" [] {
    mut branch = git branch --sort=-committerdate
        | fzf --header "Checkout recent branch" --preview "git diff --color=always {1}"
        | str trim
    if ($branch | str starts-with '* ') {
        $branch = $branch | str replace '* ' ''
    }
    git checkout $branch
}

# selects with `fzf` and edits with `nvim`
export def "fuzzy edit file" [] {
    let destination = (fd --min-depth 1
    --hidden
    --no-ignore
    --ignore-vcs
    --exclude '*.pyc'
    --exclude '*.o'
    --exclude '*.dll'
    --exclude node_modules
    --exclude .venv # also excludes nested .venv folders
    --exclude .git
    -- . # any name
    | fzf
    --preview 'bat {} --color always'
    --bind 'focus:transform-header:file --brief {}'
    ) # pipe it to fzf
    nvim $destination
}

export alias e = fuzzy edit file

# returns the top level of a git repository, if any. Otherwhise, the same folder
def "git top level folder" [] {
    let current_directory = pwd
    if (git rev-parse --show-toplevel | is-empty) {
        return $current_directory
    }
    return (git rev-parse --show-toplevel)
}

# fast `cd`
export def --env "fuzzy find directory" [] {
    let dir = git top level folder # dir to start searching

    let destination = (
        fd --type directory
        --hidden
        --no-ignore
        --ignore-vcs
        --exclude node_modules
        --exclude .git
        # python
        --exclude '**/.venv/**'
        # rust
        --exclude '**/target/**/build/**'
        --exclude '**/target/**/incremental/**'
        --exclude '**/target/**/.fingerprint/**'
        # php
        --exclude 'vendor/**'
        -- . # any name
        $dir # dir to start searching
        | fzf # pipe it to fzf
    )
    cd $destination
}

export alias d = fuzzy find directory
