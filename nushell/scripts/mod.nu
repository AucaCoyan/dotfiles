export use copy_subs.nu
export use edit.nu
export use fzf.nu *
export use git.nu
export use helix.nu
# export use oil.nu
# export use nvim.nu
export use oss.nu
export use python.nu
export use system.nu
export use typescript.nu
export use yazi.nu *

# open git folder in $EDITOR
export def --env g [] {
    let directory = f
    code $directory
}

export def user-profile-path [] {
    [
        $env.USERPROFILE,
        "\\repos\\dotfiles\\Powershell\\oh-my-posh.config.json"
    ]
    | str join
}

export def new-junction [
    name: path               # origin, or folder you want to Symlink
    target: path             # destination, or the folder you want to refer
    ] {

    if $nu.os-info.name == "windows" {
        let command = ([
        "New-Item",
        "-ItemType",
        "SymbolicLink",
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
    } else {
        let command = ([
        "ln",
        "-s",
        $target
        $name,
        ] |
        str join
        ' '     # add this separator to join with spaces
        )
        echo $command
        bash -c $command
    }
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
        print "📦 extracting zip..."

        if $nu.os-info.name == "windows" {
            pwsh -c $"Expand-Archive -Path ($file)" # -DestinationPath C:\Test"
        } else if $nu.os-info.name == "linux" {
            unzip $file
        }
    }

    if $file_extension == 'gz' and ($file | path parse | get stem | str ends-with 'tar') {
        print "📦 extracting tar.gz..."
        tar -xvzf $file
    } else if $file_extension == 'xz' and ($file | path parse | get stem | str ends-with 'tar') {
        print "📦 extracting tar.xz..."
        tar -xJf $file
    } else {
        error make {msg: $"I don't know how to extract ($file_extension)", }
    }
}

# recibe un json de log de botmaker y devuelve una tabla con el resultado
export def "parse botmaker response" [json: record] {
    $json | get result | from json
}


export def "clean-notes" [] {
    cd ~/OneDrive/notes
    glob '**/*{frankendebian,Mac mini}*' --exclude ['**/.obsidian/**/*']
}
