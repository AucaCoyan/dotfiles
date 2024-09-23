export module "check pr" {
    export def "espanso" [] {
        print " checking format"
        cargo fmt --all -- --check

        print " running cargo clippy"
        cargo clippy --workspace --all-targets --all-features --locked --no-deps
        # if $nu.os-info.name == "windows" {
        #     cargo clippy -- -D warnings
        # } else if $nu.os-info.name = "linux" {
        #     cargo clippy -p espanso --features wayland -- -D warnings
        # } else {
        #     error make {msg: "cargo build not configured!" }
        # }

        print " running cargo build"
        if $nu.os-info.name == "windows" {
            cargo make -- build-binary
        } else if $nu.os-info.name == "linux" {
            print " building for wayland"
            cargo make --env NO_X11=true --profile release -- build-binary
        } else {
            error make {msg: "cargo build not configured!" }
        }

        print " running cargo test"
        cargo test
    }

    export def "nushell" [] {
        print "you already have toolkit.nu!"
    }
}

export module "pr counts" {
# Readme
# a .mailmap file needs to be in the root of each repo to aggregate users with multiple email addresses
# we could add users if we need to map multiple email addresses to a single user
# and commit the mailmap file to the repo if we wanted to. Format of the mailmap file is at the
# end of the script.
#
# 1. git clone every repo in the list
# 2. setup repos_root_folder to match your system
# 3. setup the proper slash by system (TODO make the slash system agnostic)
# 4. setup the output folder to the path you want it in

# Generate PR Counts for the XX Clubs.
# example usage: get_pr_counts true
# If true is provided as an argument, the script will also generate CSV files for each
# repo with one line per commit, username, email, date in order for you to figure out
# if you need to update the mailmap file so you can merge mutliple users into one.
# If false is provided as an argument, the script will summarize the PR counts and
# display a table with the top 50 rows.
# Whether you run in debug_csv mode or not, the output is written to csv files in the
# $repos_root_folder/20k folder
export def get_pr_counts [debug_csv: bool, repos_root_folder = 'C:/Users/aucac/other-repos/espanso'] {
    # let repos_root_folder = 'c:\users\dschroeder\source\repos\forks'
    # let repos_root_folder = '/Users/fdncred/src/forks'
    let repos = [[name, folder];
        [espanso, $'($repos_root_folder)(char psep)espanso'],
        [hub, $'($repos_root_folder)(char psep)hub'],
        [hub-frontend, $'($repos_root_folder)(char psep)hub-frontend'],
        [website, $'($repos_root_folder)(char psep)website'],
    ]

    let output_folder = $'($repos_root_folder)(char psep)20k'
    if not ($output_folder | path exists) {
        mkdir $output_folder
    }

    $repos | each {|repo|
        let repo_name = $repo.name
        let repo_folder = $repo.folder

        let output_file = $'($output_folder)(char psep)($repo_name).csv'
        print $"Working on ($repo_name). Saving to ($output_file)."

        cd $repo.folder

        if $debug_csv {
            # This outputs commit, name, email, date for use for adding info to mailmap file
            git log --pretty=%h»¦«%aN»¦«%aE»¦«%aD |
                lines |
                split column "»¦«" commit name email date |
                upsert date {|d| $d.date | into datetime} |
                to csv |
                save -f ($output_file)
        } else {
            git log --pretty=%h»¦«%aN»¦«%aE»¦«%aD |
                lines |
                split column "»¦«" commit name email date |
                upsert date {|d| $d.date | into datetime} |
                group-by name |
                transpose |
                upsert column1 {|c| $c.column1 | length} |
                sort-by column1 |
                rename name commits |
                reverse |
                to csv |
                save -f ($output_file)
        }
    }

    cd $output_folder

    if not $debug_csv {
        let data = (open docs.csv |
            append (open espanso.csv) |
            append (open hub.csv) |
            append (open hub-frontend.csv) |
            append (open website.csv)
        )

        let data_dfr = ($data | dfr into-df)
        $data_dfr |
            dfr group-by name |
            dfr agg [(dfr col commits | dfr sum | dfr as "all_commits")] |
            dfr collect |
            dfr sort-by all_commits |
            dfr reverse |
            dfr into-nu |
            first 50
    }
}

export def run_pr_counts [] {
    # .mailmap file
    # format
    # new_name <new_email> old_name <old_email>
    # name <email_we_now_want_to_use> some old name <old email address1>
    # name <email_we_now_want_to_use> some old name <old email address2>
    # name <email_we_now_want_to_use> some old name <old email address3>
    # name <email_we_now_want_to_use> some old name <old email address4>

    use ./list-merged-prs.nu

    const LAST_RELEASE = "v2.2.1"

    let matching_releases = ^gh api /repos/espanso/espanso/releases
        | from json
        | where tag_name == $LAST_RELEASE

    match ($matching_releases | length) {
        0 => {
            error make --unspanned { msg: "no matching releases... did you set the last release?" }
        },
        1 => {},
        _ => {
            error make --unspanned { msg: $"too many matching releases... is ($LAST_RELEASE) correct?" }
        },
    }

    let last_release_date = $matching_releases | into record | get published_at | into datetime
    print $last_release_date

    let prs = list-merged-prs espanso/espanso --date $last_release_date
        | where author != "app/dependabot"
        | sort-by mergedAt
        | update url {|it| $"[#($it.number)]\(($it.url)\)" }
        | update author { $"[@($in)]\(https://github.com/($in)\)" }
        | select author title url
        | rename --column {url: pr}

    print "ALL PRS:"
    print ($prs | to md --pretty)

    print "BREAKING CHANGES:"
    mut breaking_prs = list-merged-prs espanso/espanso --date $last_release_date --label breaking-change --pretty --no-author
    $breaking_prs ++= (list-merged-prs espanso/espanso --date $last_release_date --label 'pr:breaking-change' --pretty --no-author)
    print ($breaking_prs | to md --pretty)

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
        let list_of_repos = [
            "espanso/espanso"
            "espanso/website"
            "espanso/hub"
            "espanso/hub-frontend"
        ]

        clone all $list_of_repos $"($env.home)/other-repos/espanso"
    }

    export def --env "espanso forks" [] {
        let repos_dir = $"($env.home)/repos"
        
        let list_of_repos = [
            "espanso"
            "website"
            "hub"
            "hub-frontend"
        ]

        clone all $list_of_repos $repos_dir
    }

    export def --env "nushell repos" [] {
        let nu_dir = $"($env.home)/other-repos/nu"

        let list_of_repos = [
            "nushell"
            "nu_scripts"
            "vscode-nushell-lang"
        ]

        clone all $list_of_repos $nu_dir
    }

    export def --env "nushell forks" [] {
        let repos_dir = $"($env.home)/repos"
        
        let list_of_repos = [
            "nushell"
            "nu_scripts"
            "vscode-nushell-lang"
        ]

        clone all $list_of_repos $repos_dir
    }
}