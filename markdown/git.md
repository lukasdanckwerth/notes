# `git`

> Collection of common `git` commands and working steps.

- [Create tag](#create-tag)
- [Create branch](#create-branch)
- [Remove branch](#remove-branch)

### Create tag

```bash
# list tags
$ git tag

# create tag
$ git tag -a v1.4 -m 'my version 1.4'

# Push (all new) tags to remote server
$ git push origin --tags
```

### Create branch

```bash
# create the branch
$ git branch THE_BRANCH

# switch to branch
$ git checkout THE_BRANCH

# ... or shorthand:
$ git checkout -b THE_BRANCH

# create branch on remote server
$ git push origin THE_BRANCH
```

### Remove branch

```bash
# To delete a local branch
$ git branch -d THE_BRANCH

# To remove a remote branch (be careful!)
$ git push origin THE_BRANCH

# or simply use the new syntax (v1.7.0)
$ git push origin --delete THE_BRANCH
```
