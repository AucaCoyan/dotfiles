export def kill-java-process [] {
    ps
    | where name =~ 'java'
    | each {
        |java_ps|
        kill $java_ps.pid
        }
}