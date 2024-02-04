let start = "let files = ["
let files  = glob **/*.nu --exclude [before_v0.60/**]

let new_list = $files | str join ",\n" | append "]"

let final = "
for file in $files {
    print $\"checking ($file)\"
    let result = nu-check $file
    if $result {
        print $\" ($file) is ok\"
    } else {
        print $\"oh no! ($file) is wrong!\"
        break
    }
}"


$start 
| append $new_list
| append $final 
| save "check-files.nu" --force

