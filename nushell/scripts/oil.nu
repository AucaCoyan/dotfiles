# !!! Requires "std edit" and "fd"
# --> https://gist.github.com/ClipplerBlood/4a36c677c79ee7c67f81b5bd30b30478

export def "main" [] {
    
    def where-file [] {
        $in | where {|| ($in | str contains ".")}
    }

    def where-dir [] {
        $in | where {|| not ($in | str contains ".")}
    }

    def fType [s: string] {
        if ($s | str contains ".") {"file"} else {"dir"}
    }

    let editedDir = (
        fd 
        | std edit oil 
        | split row "\n" 
        | each {|| $in | str trim}
        | where {|| not ($in | is-empty)}
    )

    # Filter things to add
    let toAdd = $editedDir | where {|| not ($in | path exists)}
    let toAddFiles = $toAdd | where-file
    let toAddDirs  = $toAdd | where-dir

    # Filter things to del
    let toDel = fd
        | split row "\n"
        | where {|| not ($in | is-empty)}
        | where {|| not ($in in $editedDir)}

    let toDelFiles = $toDel | where-file
    let toDelDirs = $toDel | where-dir
    

    # Build the changes table
    let changes = $toAdd
        | each {|| {
            operation: $"(ansi green)ADD(ansi reset)", 
            path: $in, 
            type: (fType $in)}}
        | append (
            $toDel
            | each {|| {
                operation: $"(ansi red)DEL(if (fType $in) == "dir" {' '} else {''})(ansi reset)", 
                path: $in, 
                type: (fType $in)}}
        )

    # Early return
    if ($changes | is-empty) {
        return "No changes to apply"
    }

    # List changes
    print "The following changes will be applied."
    if not ($toDelDirs | is-empty) {
        print $"(ansi yellow) Deleting folders will also delete their contents (ansi reset)"
    }
    print $changes
    
    # Prompt user for confirm
    let confirmed = input "Do you confirm the changes? Type \"yes\"\n"

    if ($confirmed | str downcase | $in != "yes") {
        return "Aborted"
    }

    # Operations
    $toAddFiles | each {|e|
        $e
        | path split
        | reduce -f "" {|p, acc| 
            let $currPath = [$acc $p] | path join  
            if not ($currPath | path exists) {
                if ($p | str contains ".") {
                    touch $currPath
                } else {
                    mkdir $currPath
                }
            }
            $currPath
        }
        print $"(ansi green)󰝒 Created file ($e)(ansi reset)"
    }

    $toAddDirs | each {|e| 
        mkdir $e
        print $"(ansi green)󰉗 Created dir ($e)(ansi reset)"
    }

    $toDelFiles | each {|e| 
        rm -t $e
        print $"(ansi red)󰮘 Deleted file ($e)(ansi reset)"
    }

    $toDelDirs | each {|e| 
        rm -t -r -f $e
        print $"(ansi red)󰉘 Deleted folder ($e)(ansi reset)"
    }

    print ""
    null
}

# Opens the editor with the piped input.
#
# Examples:
# > "hello world" | std edit | split row " "
def "std edit" [
    buffer?: string = "nu_std_edit.nu"    # The temporary file name
    editor?: string        # The editor command. Defaults to $env.EDITOR, $env.VISUAL or $env.config.buffer_editor
    --commandline (-c)     # Sets the commandline to the output. Otherwise, the output is simply returned
] {
    # Definitions
    let content = $in | default ""
    let buffer = $env.TEMP? | default $env.TMP? | default "/tmp" | path join $buffer
    let editor = $editor | default $env.EDITOR? | default $env.VISUAL? | default $env.config?.buffer_editor?
    
    if $editor == null {
        if $env.EDITOR == null {
        error make { msg: "Editor not found!" }
        } else {
            $editor = $env.EDITOR
        }
    }

    # Save content to file
    if ($content | is-empty) {
        "" | save --force $buffer
    } else {
        $content | save --force $buffer
    }

    # Run editor command
    run-external $editor $buffer

    # Return based on -c flag
    if $commandline {
        commandline (open $buffer | str trim)
    } else {
        open $buffer
    }
}