export use copy_subs.nu
export use edit.nu
export use fzf.nu *
export use git.nu
export use helix.nu
# export use oil.nu
export use nvim.nu
export use oss.nu
export use python.nu
export use system.nu
export use typescript.nu
export use yazi.nu

export def --env f [
    --all # include ~/all-repos folder
] {
    # Usage: fd.exe [OPTIONS] [pattern] [path]...
    # if $all {
        let destination = (fd --max-depth 1 --min-depth 1
        --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules 
        -- . # any name
        ~/repos #all these dirs
        ~/other-repos
        ~/all-repos/botmaker
        ~/all-repos/gcp-source
        ~/workspace
        ~/workspace/private
        ~/workspace/botmaker
        ~/workspace/dataflow
        | fzf) # pipe it to fzf
        cd $destination
    # } else {
    #     let destination = (fd --max-depth 1 --min-depth 1
    #     --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules 
    #     -- . # any name
    #     ~/repos #all these dirs
    #     ~/other-repos
    #     ~/workspace
    #     ~/workspace/private
    #     ~/workspace/botmaker
    #     ~/workspace/dataflow
    #     | fzf) # pipe it to fzf
    #     cd $destination
    # }
}

# updates the fork based on `main` branch of the remote `upstream`
export def update-the-fork [branch?: string = "main"] {
    print "⏬ fething upstream"
    #TODO check if `upstream` is in the list of remotes
    # ^git remote
    # | lines
    ^git fetch upstream
    print $"\n✔  done\n🏁 checking out ($branch)"
    ^git checkout $branch
    print $"\n✔  done\n💫 rebasing from upstream/($branch)"
    git rebase $"upstream/($branch)"
}

# <repo: > fork the repo and clones it on ~/repos/
export def --env "fork this" [ghrepo:string] {
    cd ~/repos
    print "⏬ fork + clone the repo"
    ^gh repo fork $ghrepo --clone --default-branch-only
    let folder = gh repo view $ghrepo --json name | from json | get name
    cd $"~/repos/($folder)"
}

export def list_scoop_packages [] {
    (
    scoop export 
        | from json             # convert raw input to json
        | get apps              # get only the key "apps"
        | select Name Version   # select the columns Name and Version
      # | to json               # transform it to json
    )

    # save "current-scoop-pkgs.txt"  # save to txt file

# alternative
#  open scoop-list.json | get 'apps' | select Name | to text | save "1.txt"
# scoop export | from json | get apps | select Name | to text | save "2.txt"
}

export def user-profile-path [] {
    [
        $env.USERPROFILE,
        "\\repos\\dotfiles\\Powershell\\oh-my-posh.config.json"
    ] 
    | str join
}

export def new-junction [
    --name: path               # origin, or folder you want to Symlink
    --target: path             # destination, or the folder you want to refer
    ] {

    if $nu.os-info.name == "windows" {
        let command = ([
        "New-Item",
        "-ItemType",
        "Junction",
        "-Path",
        $name,
        "-Target",
        $target
        ] |
        str join 
        ' '     # add this separator to join with spaces 
        )
        echo $command
        pwsh -Command $command
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented" }
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
}

export def git-gone [] {
    git branch --merged 
    | lines 
    | where $it !~ '\*' 
    | str trim 
    | where $it != 'master' and $it != 'main' 
    | each {
         |it| git branch -d $it 
         }
}

export def "update broot" [] {
    print "💫 updating broot"

    broot --print-shell-function nushell
    | save $"($env.home)/repos/dotfiles/nushell/cfg_files/broot.nu" --force

    print "✅ done!"
}

# (external) Parse text from a JWT and create a record.
export def "from jwt" []: string -> record {
    (split row .  | {
        header:    ($in.0 | decode base64 --url --nopad | decode )
        payload:   ($in.1 | decode base64 --url --nopad | decode )
        signature: ($in.2 | decode base64 --url --nopad | decode )
      } | convert-datetime 'exp' 
      | convert-datetime 'iat'
      | convert-datetime 'nbf'
    )
}

def "convert-datetime" [field: string] {
    if ($in.payload | columns | any { $in == $field }) {
        $in | update payload { update $field { timestamp into datetime } }
    } else {
        $in
    }
}

def "timestamp into datetime" [] {
    $in * 1_000_000_000 | into datetime
}

export def extract [file: path] {
    let file_extension =  $file | path parse | get extension
    if $file_extension == 'zip' {
        print "it's a zip"
        print 'not implemented!'
    }

    if $file_extension == 'gz' and ($file | path parse | get stem | str ends-with 'tar') {
        print "it's a tar.gz"
        tar -xvzf $file
    }
}

# recibe un json de log de botmaker y devuelve una tabla con el resultado
export def "parse botmaker response" [json: record] {
    $json | get result | from json
}
