# looks for the subtitles folder, then rename and move de sub to the parent folder
export def main [folder: path] {
    # copy a backup just in case
    cp $folder backup
    cd $folder
    let files = ls | where type == dir | get name
    print $files
    # print ($files | describe) list<string>

#    for $el in $files {
#        cd $el
#        let subs = ls --full-paths | get name | path basename
#        print $"dir name is: ($el)"
#        print $"file name is: >($subs)<"
#        let files2 = ls
#        print $files2
#        mv --verbose $"($subs)" $"..\\($el).srt"
#        # cp $subs ..
#        # cd ..
#        # mv --verbose $".\\($subs)" $"($el).srt"
#        break
#        cd ..
#        }
    $files | each { |dir|

        cd $dir
        mv "2_English.srt" $"..\\..\\($dir).srt"
        ls
    }
}

# export def "rename multiple subs" [] {
    # let videos = ls *.mp4 | get name # list<string>
    # $videos | each { |subtitlename|
        # str distance
    # }
# }
