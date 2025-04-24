# Publishing Your Monorepo to GitHub: A Step-by-Step Guide

This guide will walk you through the process of publishing your Krabbel monorepo to GitHub.

## What is a Monorepo?

A monorepo (short for "monolithic repository") is a version control strategy where multiple projects or components are stored in a single repository. In the case of Krabbel, both the Spring Boot backend and Vue.js frontend are stored together.

Benefits of this approach include:
- Simplified dependency management
- Atomic changes across projects
- Consistent developer experience
- Easier code sharing and reuse

## Prerequisites

1. [Git](https://git-scm.com/downloads) installed on your machine
2. A [GitHub](https://github.com/) account
3. Your Krabbel project on your local machine

## Step 1: Initialize Git Repository

First, let's initialize a Git repository in your project root directory:

```bash
# Navigate to your project root directory
cd /path/to/Krabbel

# Initialize a new Git repository
git init
```

## Step 2: Create .gitignore Files

Create appropriate `.gitignore` files to exclude unnecessary files from version control:

**Root .gitignore:**

```bash
# Create a .gitignore file in the root directory
touch .gitignore
```

Add the following content to this file:

```
# IDE files
.idea/
.vscode/
*.iml

# Logs
logs/
*.log

# OS generated files
.DS_Store
Thumbs.db

# Node modules
node_modules/

# Environment files
.env
.env.local
.env.*.local

# Maven build directory
target/

# Frontend build directory
frontend/dist/
```

## Step 3: Make Initial Commit

Now let's add all the project files and make an initial commit:

```bash
# Add all files to staging
git add .

# Make the initial commit
git commit -m "Initial commit of Krabbel - Full stack note-taking application"
```

## Step 4: Create a GitHub Repository

1. Sign in to [GitHub](https://github.com/)
2. Click the "+" icon in the top-right corner and select "New repository"
3. Name your repository (e.g., "Krabbel")
4. Add a description (optional)
5. Choose whether to make it public or private
6. Do NOT initialize with a README, .gitignore, or license (since we're pushing an existing repo)
7. Click "Create repository"

## Step 5: Connect and Push to GitHub

After creating the repository, GitHub will show instructions for pushing an existing repository. Use the commands:

```bash
# Add the GitHub repository as a remote named "origin"
git remote add origin https://github.com/YOUR-USERNAME/Krabbel.git

# Push your code to the GitHub repository
git push -u origin main
```

Note: If your default branch is named "master" instead of "main", use:

```bash
git push -u origin master
```

## Step 6: Verify the Repository

1. Refresh your GitHub repository page
2. You should see all your code, including both the backend and frontend components
3. GitHub will automatically detect your README.md and display it on the repository homepage

## Working with the Monorepo

### Standard Git Workflow

For your daily workflow:

```bash
# Pull latest changes
git pull

# Create a new branch for your feature
git checkout -b feature/my-new-feature

# Make changes...

# Add and commit changes
git add .
git commit -m "Add new feature: description"

# Push to GitHub
git push -u origin feature/my-new-feature

# Then create a Pull Request on GitHub
```

### Managing Independent Components

While you have both frontend and backend in one repository, you can still work on them independently:

1. **Separate commits**: You can commit changes to the frontend and backend separately
2. **Branch naming**: Use prefixes like `backend/` or `frontend/` for feature branches
3. **Pull Requests**: Clearly describe which component is affected

## Monorepo Best Practices

1. **Clear organization**: Maintain a clear directory structure
2. **Component-specific configuration**: Keep component-specific configuration files in their respective directories
3. **Shared documentation**: Keep high-level documentation in the root directory
4. **Explicit dependencies**: Be explicit about dependencies between components

## Alternatives to Consider

If you find managing a monorepo challenging, you can also:

1. **Split into separate repositories**: Move the frontend and backend into separate repositories
2. **Use Git submodules**: Keep separate repositories but link them with Git submodules
3. **Use a monorepo tool**: Tools like Lerna, Nx, or Turborepo can help manage complex monorepos

## Advanced: Continuous Integration

Consider setting up CI/CD for your monorepo:

1. Create a `.github/workflows` directory
2. Add GitHub Actions workflows for frontend and backend
3. Configure build, test, and deployment steps

Example GitHub Actions workflow (`.github/workflows/ci.yml`):

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'adopt'
      - name: Build with Maven
        run: cd backend && mvn clean verify

  frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Use Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - name: Install dependencies
        run: cd frontend && npm ci
      - name: Build
        run: cd frontend && npm run build
```

## Conclusion

You've now successfully published your Krabbel monorepo to GitHub! This approach gives you a solid foundation for continued development while keeping all related code in one place. 