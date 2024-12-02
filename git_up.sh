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
        # First try to get a summary of changes
        files_changed=$(git diff --cached --numstat | wc -l)
        summary=$(git diff --cached --stat | tail -n1)
        
        # Get a truncated diff, but much smaller than before
        git_diff=$(git diff --cached | head -c 50000)
        
        # If the diff is empty, exit early
        if [ -z "$git_diff" ]; then
            echo "No changes to commit"
            exit 0
        fi

        # Construct a more informative prompt with the summary
        llm "I have changes affecting $files_changed files. Here's the summary:
$summary

And here's a truncated diff of the changes:

\`\`\`
$git_diff
\`\`\`

Write a concise commit message for these changes using less than 10 words. Use emoji when appropriate. Focus on the main purpose of the changes."
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