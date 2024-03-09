export def files [path?: path] {
    let start = "let files = ["
    let files  = glob **/*.nu --exclude [before_v0.60/**]

    let new_list = $files | str join ",\n" | append "]"

    let final = "
    for file in $files {
        let diagnostics_table = nu --ide-check 10 $file | to text  | ['[', $in, ']'] | str join | from json
        let result = $diagnostics_table | where type == \"diagnostic\" | is-empty
        if $result {
            # print $\"✔ ($file) is ok\"
        } else {
            print $\"❌ ($file) has errors:\"
            print ($diagnostics_table | where type == \"diagnostic\")
        }
    }
    "

    $start 
    | append $new_list
    | append $final 
    | save "check-files.nu" --force
}