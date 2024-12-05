# Skip Repository Archiver Script

## Overview

This script automates the process of archiving previously created GitHub repositories and creating a new GitHub repository. It uses the GitHub CLI (`gh`) to interact with the GitHub API and authenticate via a personal access token (`GIT_TOKEN`). It also manages the Git configuration and ensures that your repositories are archived correctly before creating new ones.

### Features:
- Archives the most recent repository created on the same day.
- Creates a new repository with a name prefixed with "Skip-" and the current date and time.
- Automates the process of pushing the newly created repository to GitHub with basic HTML, CSS, and JavaScript files.
- Includes authentication via GitHub token for seamless operation without needing to enter a username/password.

## Prerequisites

Before running the script, ensure that you have the following prerequisites installed:

1. **Git**: Used for managing repositories locally and pushing to GitHub.
2. **GitHub CLI (gh)**: Required for interacting with GitHub via the command line.
3. **jq**: A command-line JSON processor for parsing API responses.
4. **zip**: For compressing archived repositories.
   
You can install these tools with the following commands (assuming you're using a Debian-based system like Ubuntu):

```bash
sudo apt update
sudo apt install git gh jq zip
```

Additionally, you'll need to set up your **GitHub personal access token** (`GIT_TOKEN`) with the required scopes for repository creation and management. 

### Note:
- Make sure your GitHub account is authenticated using the `gh` CLI before running the script.
- If running the script as a non-root user, make sure the script has the required permissions to create directories and execute commands.

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Lalatenduswain/Repository-Archiver-Skip.git
   cd Skip-Repository-Archiver
   ```

2. Ensure the script is executable:

   ```bash
   chmod +x create_github_repo.sh
   ```

3. Run the script:

   ```bash
   ./create_github_repo.sh
   ```

4. The script will:
   - Archive the most recent repository created on the same day.
   - Create a new repository with a name like `Skip-2024-12-05_16-39-07`.
   - Populate the new repository with an `index.html`, `index.js`, and `style.css` file.
   - Push the new repository to GitHub.

## Explanation of the Script

The script follows a series of steps:

1. **Configuration**: It starts by setting up Git configuration for your username and email.
   
2. **Repository Archiving**: If there is a previously created repository on the same day, the script will:
   - Clone the repository locally.
   - Create a zip file of the repository for archiving.
   - Delete the local clone after the archival process is completed.
   
3. **Repository Creation**: 
   - It uses the GitHub CLI to authenticate using a personal access token and create a new repository with a unique name based on the current timestamp.
   - The repository is cloned to the local machine.

4. **File Creation**: 
   - It generates basic web files (`index.html`, `index.js`, and `style.css`) with dummy content.
   
5. **Commit and Push**:
   - The script stages the new files, commits them, and pushes them to the newly created repository on GitHub.

6. **Clean-up and Logging**: 
   - After pushing, the script logs the repository name in a local file and prints a success message.

## Disclaimer | Running the Script

**Author:** Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script is provided as-is and may require modifications or updates based on your specific environment and requirements. Use it at your own risk. The authors of the script are not liable for any damages or issues caused by its usage.

## Donations

If you find this script useful and want to show your appreciation, you can donate via [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain).

## Support or Contact

Encountering issues? Don't hesitate to submit an issue on our [GitHub page](https://github.com/Lalatenduswain/Skip-Repository-Archiver/issues).

---

**Please Note:** Replace `Skip-Repository-Archiver` with the actual script name or repo name you choose.
