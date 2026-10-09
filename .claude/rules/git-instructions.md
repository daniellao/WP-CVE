# Git rules

- Read-only git commands (`git status`, `git diff`, `git log`, `git show`, `git blame`, `git worktree list`, …) are fine anytime, as often as needed.
- NEVER run git commands that change staging, working tree, or history – `git add` (stage), `git reset` / `git restore --staged` (unstage), `git commit`, `git push`, `git stash`, branch-changing `git checkout`/`git switch`, `git rebase`, `git merge` – unless the user explicitly tells you to in that same message. The user manages their own staging while reviewing; do not stage, unstage, commit, or push on your own initiative, and never interfere with their staged/unstaged state.
- A scoped instruction authorizes only that exact action: "stage X" means stage X and nothing else – it does not authorize unstaging, resetting, committing, or touching any other file.
- The user pushes branches themselves – never push.
- **Commits (when asked):** headline only, repo convention `type(scope): summary` (see `style-guide/style-guide.git.md`); no body unless the user explicitly asks for one; never mention yourself or your tooling in the message.
- **Branches:** `feature/short-description` or `fix/short-description`, prefixed with the ticket number when there is one (e.g. `feature/1234-booking-filter`).
- **Worktrees:** the user keeps using the main checkout (Git UI, other agents) and may switch branches mid-session. For reviews and multi-branch work create a worktree and use absolute paths.
