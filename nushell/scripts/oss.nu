export module "check pr" {
    export def "espanso" [] {
        print " running cargo check"
        cargo check
        print " running cargo build"
        cargo build
        print " running cargo test"
        cargo test
    }

    export def "nushell" [] {
        print "you already have toolkit.nu!"
    }
}

# grabs the repo name of a github (ORG/repo) string
# 
# for exaple 
# grab repo name "organization/my_special_repo" 
# returns "myspecial_repo" 
export def "grab repo name" [ghrepo: string]: [string -> string] {
    $ghrepo | split column "/" | get column2 | last
}

# Generic fn to clone all repos of one organization into a specific folder
# 
# # Parameters
# `list_of_repos` is a list of <ORG/REPO> from github
#   for example:
# ```nu
# let list_of_repos = [
#     "espanso/espanso"
#     "espanso/website"
#     "espanso/hub"
#     "espanso/hub-frontend"
# ]
#
# and destination is the location where those repos are cloned
# $ use oss.nu clone all
# $ clone all ['espanso/website'] /home/my-dir/
# equals
# gh repo clone espanso/website /home/my-dir/website
# (note that it doesn't create the organization folder)
export def "clone all" [list_of_repos: list<string>, destination: path] {
        print $" creating ($destination) folder"
        mkdir $destination
        
        for $repo in $list_of_repos {
            let repo_name = grab repo name $repo
            let single_repo_dir = $"($destination)/($repo_name)"
            if ($single_repo_dir | path exists) {
                print $"\n repo ($single_repo_dir) exists, skipping"
                continue
            } else {
                print $"\n cloning ($repo)"
                gh repo clone $repo $single_repo_dir
            }
        }
}

# clone repos
export module "clone all" {
    export def --env "espanso repos" [] {
        print " creating ~/other-repos/espanso folder"
        let espanso_dir = $"($env.home)/other-repos/espanso"
        mkdir $espanso_dir
        
        let list_of_repos = [
            "espanso"
            "website"
            "hub"
            "hub-frontend"
        ]
        for $repo in $list_of_repos {
            let single_repo_dir = $"($espanso_dir)/($repo)"
            if ($single_repo_dir | path exists) {
                print $"\n repo ($single_repo_dir) exists, skipping"
                continue
            } else {
                print $"\n cloning espanso/($repo)"
                gh repo clone $"espanso/($repo)" $single_repo_dir
            }
        }
    }

    export def --env "espanso forks" [] {
        let repos_dir = $"($env.home)/repos"
        
        let list_of_repos = [
            "espanso"
            "website"
            "hub"
            "hub-frontend"
        ]
        for $repo in $list_of_repos {
            let single_repo_dir = $"($repos_dir)/($repo)"
            if ($single_repo_dir | path exists) {
                print $"\n repo ($single_repo_dir) exists, skipping"
                continue
            } else {
                print $"\n cloning AucaCoyan/($repo)"
                gh repo clone $"AucaCoyan/($repo)" $single_repo_dir
            }
        }
    }

    export def --env "nushell repos" [] {
        print " creating ~/other-repos/nu folder"
        let nu_dir = $"($env.home)/other-repos/nu"
        mkdir $nu_dir

        let list_of_repos = [
            "nushell"
            "nu_scripts"
            "vscode-nushell-lang"
        ]
        for $repo in $list_of_repos {
            let single_repo_dir = $"($nu_dir)/($repo)"
            if ($single_repo_dir | path exists) {
                print $"\n repo ($single_repo_dir) exists, skipping"
                continue
            } else {
                print $"\n cloning nushell/($repo)"
                gh repo clone $"nushell/($repo)" $single_repo_dir
            }
        }
    }

    export def --env "nushell forks" [] {
        let repos_dir = $"($env.home)/repos"
        
        let list_of_repos = [

            "nushell"
            "nu_scripts"
            "vscode-nushell-lang"
        ]
        for $repo in $list_of_repos {
            let single_repo_dir = $"($repos_dir)/($repo)"
            if ($single_repo_dir | path exists) {
                print $"\n repo ($single_repo_dir) exists, skipping"
                continue
            } else {
                print $"\n cloning AucaCoyan/($repo)"
                gh repo clone $"AucaCoyan/($repo)" $single_repo_dir
            }
        }
    }
}