git-simple-subsplit
===================

A git subtree/subsplit script for quickly creating one-way subsplit of repositories. (use for composer packages)

##Usage

sync master branch
```
cd repo
git-simple-subsplit.sh path git@github.com:user/subrepo.git
```

sync other branch:
```
cd repo
git-simple-subsplit.sh path git@github.com:user/subrepo.git other
```

##Workflow for creating and syncing sub-repos

### Create

```sh
git clone https://github.com/user/masterrepo masterrepo
cd masterrepo
git-simple-subsplit.sh path1 git@github.com:user/subrepo1.git
git-simple-subsplit.sh path2 git@github.com:user/subrepo2.git
git-simple-subsplit.sh path2 git@github.com:user/subrepo2.git otherbranch
...
```

### Update

Same as "Create" but it will use existing repo and cached data so only add new commits which is much faster.

```sh
cd masterrepo
git-simple-subsplit.sh path1 git@github.com:user/subrepo1.git
git-simple-subsplit.sh path2 git@github.com:user/subrepo22git
git-simple-subsplit.sh path2 git@github.com:user/subrepo2.git otherbranch
...
```

Todo
----

Currently tags are not beeing synced.
