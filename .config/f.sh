#!/usr/bin/bash

function f {
    # 1. Define and convert directories from Windows-style to Unix-style
    # In Zsh/Unix, $HOME is used, and paths use forward slashes.
    local directories=(
        "$HOME/repos"
        "$HOME/other-repos"
        "$HOME/other-repos/nu"
        "$HOME/workspace"
    )

    # 2. Run fd and pipe its output to a variable
    # The PowerShell script passes the directories as positional arguments to fd.
    # The '.' argument is present but seems redundant if directories are specified,
    # but we'll include it for a faithful translation if 'fd' is expecting it.
    local fd_output
    fd_output=$(
        fd --max-depth 1 \
           --min-depth 1 \
           --type directory \
           --hidden \
           --no-ignore \
           --ignore-vcs \
           --exclude node_modules \
           . "${directories[@]}"
    )

    # Check if fd found any directories
    if [[ -z "$fd_output" ]]; then
        echo "Warning: 'fd' did not find any directories." >&2
        return 1
    fi

    local selected_directory

    # 3. Check for fzf and use it for selection
    # `type fzf` attempts to locate the command. `&>/dev/null` suppresses its output.
    if type fzf &>/dev/null; then
        # Use fzf to select a directory from the fd output
        # The output of fzf is piped to 'read'
        selected_directory=$(echo "$fd_output" | fzf)
    else
        echo "Warning: fzf is not installed. Using the first directory found by fd." >&2
        # Use the first line of the output if fzf is not available
        # The `read -r` command reads the first line from the string.
        selected_directory=$(echo "$fd_output" | head -n 1)
    fi

    # 4. Change directory
    if [[ -n "$selected_directory" ]]; then
        if cd "$selected_directory"; then
            # Successfully changed directory
            echo "Changed directory to: $selected_directory"
            return 0
        else
            # Error changing directory
            echo "Error: Failed to change directory to '$selected_directory'." >&2
            return 1
        fi
    else
        echo "Warning: No directory selected." >&2
        return 1
    fi
}