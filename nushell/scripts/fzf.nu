# cd into folder with `fzf`
export def --env f [] {
    let destination = (fd --max-depth 1 --min-depth 1
    --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules
    -- . # any name
    ~/repos #all these dirs
    ~/other-repos
    ~/other-repos/espanso
    ~/other-repos/nu
    ~/all-repos/
    ~/workspace
    ~/workspace/botmaker
    ~/workspace/dataflow
    ~/workspace/gcp-source
    ~/workspace/private
    ~/workspace/private/template-project
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

export def fuzzy-history-search [] { history | get command | uniq | fzf }

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


alias fef = fuzzy-edit-file

# selects with `fzf` and edits with `nvim`
export def "fuzzy-edit-file" [] {
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
    --preview 'fzf-preview.sh {}'
    --bind 'focus:transform-header:file --brief {}'
    ) # pipe it to fzf
    nvim $destination
}

export def --env "fuzzy find directory" [] {
        let destination = (fd --type directory --hidden --no-ignore
        --ignore-vcs --exclude node_modules --exclude .git
        -- . # any name
        . # This dir
        | fzf) # pipe it to fzf
        cd $destination
}


# fast `cd`
export def --env d [] {
    let destination = (fd --type directory --hidden --no-ignore --ignore-vcs
        --exclude '.git/**'
        --exclude node_modules
        --exclude '**/.venv/**'
        --exclude '**/target/**/build/**'
        --exclude '**/target/**/incremental/**'
        --exclude '**/target/**/.fingerprint/**'
    -- . # any name
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
