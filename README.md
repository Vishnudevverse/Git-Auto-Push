Here’s how you can turn your `echo` help screen into a **simple `README.md`** for your GitHub repository.

Below is a clean **Markdown** version of your script’s usage instructions:

```markdown
# Git Auto-Push Script

## How to Use This Script

```

* Type a commit message and press Enter to add, commit, and push in one go.
* S = Show git status
* B = Switch/create branch
* H = Display this help screen
* Q = Quit script

```

## What This Script Does

```

* On first run, initializes repo & sets up origin.
* Pulls existing branch or makes initial commit.
* Enters a loop for status, branch, help, commits.
* Pushes all files in the project directory.

```

## Things to Avoid

```

* Leaving the commit message blank.
* Using quotes in commit messages.
* Forgetting to save files before committing.

```

## Setup Tips

```

* Requires Windows CMD (no admin).
* Copy this `.bat` into your separate folder.
* Add that folder to your PATH.
* In VS Code, open your project.
* Open terminal (`Ctrl+``). Run `gitautopush\`.

```

---

**Enjoy auto-pushing your commits!**
```

---

### ✅ To add this to GitHub:

1. Create a file called `README.md` in the root of your repository.
2. Paste the above content into it.
3. Save, add, commit, and push:

   ```bash
   git add README.md
   git commit -m "Add usage instructions in README"
   git push origin main
   ```

Let me know if you’d like a version that keeps the ASCII box style too!
