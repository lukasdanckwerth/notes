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

### Set / change URL

```bash
$ git remote set-url origin NEW_REPOSITORY_URL
```

## Change commit message

If the commit only exists locally:

```
git commit --amend
```
> (eng.) amend = (dt.) aerndern


## Reset

Reset to `HEAD`:
```bash
# Reset single file(s)
git checkout HEAD -- myfile.txt

# Reset whole directory
git checkout HEAD 
```

## Tags

List tags:
```
git tag
```

Annotated tags, however, are stored as full objects in the Git database. They’re checksummed; contain the tagger name, email, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG).
```
git tag -a v1.0.0 -m "v1.0.0"
```

Lightweight tag is very much like a branch that doesn't change -- it's just a pointer to a specific commit.
```
git tag v1.0.0
```

## Aliases

```
git quepasa = log --graph --oneline --decorate --all --pretty="format:%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date="relative"
```

```
update = fetch --all --prune
```
