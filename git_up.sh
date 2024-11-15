#!/bin/bash
# -----------------------------------------------------------------------------
# AI-powered Git Commit Function
# Copy paste this gist into your ~/.bashrc or ~/.zshrc to gain the `gcm` command. It:
# 1) gets the current staged changed diff
# 2) sends them to an LLM to write the git commit message
# 3) allows you to easily accept, edit, regenerate, cancel
# But - just read and edit the code however you like
# the `llm` CLI util is awesome, can get it here: https://llm.datasette.io/en/stable/
gcm() {
    # Function to generate commit message
    generate_commit_message() {
        git_diff=$(git diff --cached | head -c 1000000)
        # If the diff is empty, exit early
        if [ -z "$git_diff" ]; then
            echo "No changes to commit"
            exit 0
        fi
        # Add a warning if the diff was truncated
        if [ ${#git_diff} -ge 1000000 ]; then
            echo "Warning: Changes are too large, diff has been truncated for commit message generation"
        fi
        # Here's the fix - properly escape the diff and include it in the prompt
        llm "Below is a diff of all staged changes, coming from the command 'git diff --cached':

\`\`\`
$git_diff
\`\`\`

Write a concise commit message for these changes using less than 10 words. Use emoji when appropriate."
    }

    # Function to read user input compatibly with both Bash and Zsh
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            echo -n "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # Main script
    echo "Generating commit message..."
    commit_message=$(generate_commit_message)
    echo -e "\nProposed commit message:"
    echo "$commit_message"
    if git commit -m "$commit_message"; then
        echo "Changes committed successfully!"
        return 0
    else
        echo "Commit failed. Please check your changes and try again."
        return 1
    fi
}

# Stage all changes
git add .

# Use the gcm function to generate and commit with an AI-powered message
gcm

# Push the changes to the remote repository
git push origin main

# Check if GitLab is a remote
if git remote | grep -q "gitlab"; then
    echo "Pushing changes to GitLab..."
    git push gitlab main
else
    echo "GitLab remote not found. Skipping push to GitLab."
fi