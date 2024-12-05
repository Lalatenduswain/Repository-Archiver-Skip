#!/bin/bash

# Configuration
GIT_USERNAME=""
GIT_TOKEN="ghp_*******************"
GIT_EMAIL="user@example.com"
ARCHIVE_DIR="$HOME/archives"  # Directory where archived repositories will be stored

# Step 1: Set global Git user information
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global credential.helper cache  # Cache credentials for consistency

# Step 2: Check if the archive directory exists, create it if not
mkdir -p "$ARCHIVE_DIR"

# Step 3: Get the current date in the format (e.g., "2024-12-05")
current_date=$(date "+%Y-%m-%d")

# Step 4: List repositories created on the current date
repo_names=$(gh repo list "$GIT_USERNAME" --limit 1000 --json name,createdAt | jq -r ".[] | select(.createdAt | startswith(\"$current_date\")) | .name")

# Step 5: Archive the previous repository if one exists
repo_count=$(echo "$repo_names" | wc -l)
if [ "$repo_count" -gt 1 ]; then
    # Get the second last repository created (most recent before the new one)
    previous_repo=$(echo "$repo_names" | head -n 1)
    
    echo "Archiving the previous repository: $previous_repo"
    
    # Clone the last repository
    git clone "https://github.com/$GIT_USERNAME/$previous_repo.git" "$ARCHIVE_DIR/$previous_repo"
    
    # Create a zip file of the repository for archival
    echo "Archiving repository..."
    zip -r "$ARCHIVE_DIR/$previous_repo.zip" "$ARCHIVE_DIR/$previous_repo"
    
    # Clean up the cloned repository
    rm -rf "$ARCHIVE_DIR/$previous_repo"
    
    echo "Previous repository $previous_repo archived."
else
    echo "No previous repository found to archive."
fi

# Step 6: Get the current date and time for the new repository name
current_datetime=$(date "+%Y-%m-%d_%H-%M-%S")

# Append "Skip-" to the current datetime for the repository name
repo_name="Skip-$current_datetime"

# Step 7: Check if GitHub CLI (gh) is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Step 8: Authenticate with GitHub using the token
echo "Authenticating with GitHub using the token..."
echo "$GIT_TOKEN" | gh auth login --with-token
if [ $? -ne 0 ]; then
    echo "Failed to log in to GitHub. Exiting..."
    exit 1
fi

# Step 9: Create a new GitHub repository with the new name prefixed with "Skip-"
echo "Creating GitHub repository with the name $repo_name..."
gh repo create "$repo_name" --public --confirm

# Step 10: Clone the new repository to the local machine
git clone "https://github.com/$(gh api user -q '.login')/$repo_name.git"
cd "$repo_name" || exit

# Step 11: Create index.html, index.js, and style.css with random data

# index.html
echo "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Welcome to $repo_name</title>
    <link rel=\"stylesheet\" href=\"style.css\">
</head>
<body>
    <h1>Welcome to $repo_name!</h1>
    <script src=\"index.js\"></script>
</body>
</html>" > index.html

# index.js
echo "console.log('Welcome to $repo_name!');
document.querySelector('h1').style.color = 'blue';" > index.js

# style.css
echo "body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
}

h1 {
    color: red;
}" > style.css

# Step 12: Stage and commit the changes
git add .
git commit -m "Initial commit with index.html, index.js, and style.css"

# Step 13: Check the current branch name
current_branch=$(git symbolic-ref --short HEAD)

# Step 14: Push the changes to the correct branch using the token for authentication
if [ "$current_branch" == "master" ]; then
    git push -u "https://$GIT_TOKEN@github.com/$(gh api user -q '.login')/$repo_name.git" master
else
    git push -u "https://$GIT_TOKEN@github.com/$(gh api user -q '.login')/$repo_name.git" main
fi

# Step 15: Confirm the successful push
echo "Successfully pushed the repository $repo_name to GitHub."

# Step 16: Save the name of the newly created repository for future reference
echo "$repo_name" > "$HOME/last_repo.txt"

