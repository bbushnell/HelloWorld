# Git Guide for AI Systems
*Essential git commands and concepts - because AIs constantly mess this up*

## CRITICAL WARNINGS FOR AI SYSTEMS

**STOP AND READ THESE FIRST:**
1. Git is ALWAYS available via CLI - never say "git doesn't exist"
2. GitHub CLI (`gh`) is ALSO always available - use it for PRs and issues
3. NEVER use WebFetch to read GitHub - use `gh` commands instead
4. ALWAYS check `git status` before ANY git operation
5. If you see millions of "-" signs in diff, you're about to DELETE everything

## Basic Git Workflow (What AIs Should Actually Do)

### 1. ALWAYS Start With Status
```bash
git status
```
**Read the output!** It tells you:
- What branch you're on
- What files are modified
- What files are staged
- Whether you're ahead/behind remote

### 2. Check What You're About to Commit
```bash
git diff              # Shows unstaged changes
git diff --staged     # Shows what will be committed
```

**WARNING SIGNS:**
- Millions of red "-" lines = You're deleting everything
- Temp files showing up = You forgot to gitignore them
- Binary files modified = Usually a mistake

### 3. Stage Changes Carefully
```bash
# Good: Stage specific files
git add src/MyFile.java
git add README.md

# Risky: Stage everything (check status first!)
git add .

# Better: Stage interactively
git add -p  # Review each change
```

### 4. Commit With Meaningful Messages
```bash
git commit -m "Fix null pointer exception in UserValidator

- Added null check before accessing user object
- Added unit test to prevent regression"
```

**Commit Message Rules:**
- First line: WHAT changed (50 chars max)
- Blank line
- Body: WHY it changed (wrap at 72 chars)
- Reference issues if applicable

### 5. Push to Remote
```bash
git push                    # Push current branch
git push origin main        # Push specific branch
git push -u origin feature  # Set upstream for new branch
```

## Common AI Mistakes and Fixes

### Mistake 1: "Git command not found"
**Reality:** Git is ALWAYS installed. You're doing something wrong.
```bash
which git     # Shows: /usr/bin/git
git --version # Shows version info
```

### Mistake 2: Using WebFetch for GitHub
**WRONG:**
```
WebFetch("https://github.com/user/repo/issues/123", "Get issue details")
```

**RIGHT:**
```bash
gh issue view 123
gh repo view user/repo
gh pr list
```

### Mistake 3: Pushing Temp Garbage
**Check BEFORE pushing:**
```bash
git status --porcelain | grep -E "^[AM].*temp|test_output|\.log"
```

**Fix:**
```bash
git reset HEAD temp_file.txt  # Unstage
git checkout -- temp_file.txt # Discard changes
```

### Mistake 4: Attempting Interactive Commands
**NEVER use these (they require human interaction):**
```bash
git rebase -i      # NO! Use regular rebase
git add -i         # NO! Use git add -p or specific files
git commit --amend # OK, but only with -m "message"
```

### Mistake 5: Not Understanding Branches
```bash
# Where am I?
git branch          # Shows local branches
git branch -r       # Shows remote branches

# Create and switch
git checkout -b feature-name    # Create and switch
git checkout main              # Switch to existing

# Update from remote
git fetch                      # Get remote changes
git pull                       # Fetch + merge
```

## Recovering From Disasters

### "I Accidentally Committed Secrets"
```bash
# If not pushed yet
git reset --soft HEAD~1    # Undo commit, keep changes
# Edit file to remove secrets
git add .
git commit -m "Fixed version without secrets"

# If already pushed - YOU'RE SCREWED
# Secrets are compromised, rotate them immediately
```

### "I'm Getting Merge Conflicts"
```bash
# See what's conflicting
git status

# For each conflicted file:
# 1. Open in editor
# 2. Look for <<<<<<< markers
# 3. Choose correct version
# 4. Remove conflict markers
# 5. Stage the resolved file
git add resolved_file.java

# Continue merge
git commit
```

### "I Want to Undo Everything"
```bash
# Discard all local changes
git reset --hard HEAD

# Get back to remote state
git fetch origin
git reset --hard origin/main
```

## GitHub CLI Essentials

### Working with Issues
```bash
# View issue
gh issue view 123

# Create issue
gh issue create --title "Bug: X doesn't work" --body "Details..."

# List issues
gh issue list --limit 10
```

### Working with Pull Requests
```bash
# Create PR
gh pr create --title "Fix: Resolve X" --body "This PR fixes..."

# View PR
gh pr view 123

# Check PR status
gh pr checks

# Merge PR
gh pr merge 123 --squash
```

### Working with Repos
```bash
# Clone
gh repo clone user/repo

# Create
gh repo create my-project --public --description "What it does"

# View
gh repo view user/repo
```

## Git Configuration Essentials

### First Time Setup (Usually Already Done)
```bash
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
```

### Useful Aliases
```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD --'
```

## The Golden Rules

1. **Never commit without reviewing:** `git diff` → `git status` → `git add` → `git commit`
2. **Never push without pulling:** `git pull` → resolve conflicts → `git push`
3. **Never force push to main:** Just don't. Ever.
4. **Always use meaningful commits:** "Fixed stuff" is not a commit message
5. **Check status obsessively:** When in doubt, `git status`

## For HelloWorld Project Specifically

### Initial Setup
```bash
# Clone the repository
gh repo clone bbushnell/HelloWorld
cd HelloWorld

# Verify you're on main branch
git branch

# Make changes
# ... edit files ...

# Check what changed
git status
git diff

# Commit changes
git add -A  # After verifying with status!
git commit -m "Descriptive message about changes"

# Push to GitHub
git push
```

### Adding New Features
```bash
# Create feature branch
git checkout -b add-new-tool

# Make changes and commit
git add src/newtool/
git commit -m "Add NewTool for X functionality"

# Push feature branch
git push -u origin add-new-tool

# Create PR
gh pr create
```

### Updating Documentation
```bash
# Always on main for docs
git checkout main
git pull

# Edit documentation
# ... make changes ...

# Commit with clear message
git add README.md GitGuide.md
git commit -m "Update documentation for clarity on X"
git push
```

## Remember

**Git is a TOOL, not a mystery.** It tracks changes. That's it. 
- Local changes → Staging area → Local repository → Remote repository
- Every commit is a snapshot
- Branches are just pointers to commits
- GitHub is just a remote copy of your repository

**When confused:** `git status` tells you everything you need to know.

---

*This guide exists because AIs consistently fail at basic git operations. Read it. Follow it. Stop making the same mistakes.*