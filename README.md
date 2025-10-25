# Worldshift Modding

**Important Notes:**
- Always use `git clone` instead of downloading ZIP files
- Make sure Git is properly installed before attempting to clone
- If you encounter issues, check that you have the correct repository URL
- Keep your Git installation updated for the best experience



## Installation Guide

This guide will help you install Git and download the Worldshift modding repository properly. **Important**: Downloading as a ZIP file does not work well with this project, so Git installation is required.

### Step 1: Install Git

#### Windows:
1. Go to [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Download the latest version for Windows
3. Run the installer and follow the installation wizard
4. **Important**: During installation, make sure to select "Git from the command line and also from 3rd-party software" when prompted about PATH environment
5. Complete the installation and restart your computer if prompted

#### macOS:
1. Open Terminal (Applications > Utilities > Terminal)
2. Install Xcode Command Line Tools by running:
   ```bash
   xcode-select --install
   ```
3. Or download Git from [https://git-scm.com/download/mac](https://git-scm.com/download/mac)

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install git
```

#### Linux (CentOS/RHEL/Fedora):
```bash
sudo yum install git
# or for newer versions:
sudo dnf install git
```

### Step 2: Verify Git Installation

Open Command Prompt (Windows) or Terminal (macOS/Linux) and run:
```bash
git --version
```

You should see output like: `git version 2.x.x`

### Step 3: Clone the Repository

1. Open Command Prompt (Windows) or Terminal (macOS/Linux)
2. Navigate to where you want to install the project (e.g., Desktop):
   ```bash
   cd Desktop
   ```
3. Clone the repository:
   ```bash
   git clone https://github.com/CrashDown963/Worldshift.git
   ```

4. Navigate into the project folder:
   ```bash
   cd Worldshift
   ```

### Step 4: Verify Installation

Check that all files are properly downloaded:
```bash
ls -la
# or on Windows:
dir
```

You should see the project files including `data/`, `bin/`, and other directories.

### Troubleshooting

#### Common Issues:

**"git is not recognized as an internal or external command"**
- Git is not installed or not added to PATH
- Solution: Reinstall Git and make sure to select the PATH option during installation

**"Permission denied (publickey)"**
- You're trying to clone a private repository without proper authentication
- Solution: Use HTTPS instead of SSH, or set up SSH keys

**"Repository not found"**
- The repository URL is incorrect or the repository doesn't exist
- Solution: Verify the correct repository URL

**Files appear corrupted or incomplete**
- This usually happens when downloading as ZIP
- Solution: Use `git clone` instead of downloading ZIP files

### Getting Updates

To get the latest changes from the repository:
```bash
git pull origin main
```

### Contributing

If you want to contribute changes:
1. Make your modifications
2. Add your changes: `git add .`
3. Commit your changes: `git commit -m "Your commit message"`
4. Push your changes: `git push origin main`

Every push you make, patch notes are required.

---


