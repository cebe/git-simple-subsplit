git-simple-subsplit
===================

A git subtree/subsplit script for quickly creating one-way subsplit of repositories. (use for composer packages)

Can sync branches and tags.

##Usage

General usage:

```
git-simple-subsplit.sh subpath git@remotehost:repo.git [--tags "tag1 tag2 ..."] [--branches "branch1 branch2 ..."]
```

sync all tags and branches (always uses `origin` remote for checking branches and tags):

```
cd repo
git fetch origin
git-simple-subsplit.sh subpath git@github.com:user/subrepo.git
```

sync only `master` and `other` branch and all tags:

```
cd repo
git fetch origin
git-simple-subsplit.sh subpath git@github.com:user/subrepo.git --branches "master other"
```

##Workflow for creating and syncing sub-repos

### Create

```sh
git clone https://github.com/user/masterrepo masterrepo
cd masterrepo
git-simple-subsplit.sh path1 git@github.com:user/subrepo1.git
git-simple-subsplit.sh path2 git@github.com:user/subrepo2.git
...
```

### Update

Same as "Create" but it will use existing repo and cached data so only add new commits which is much faster.

```sh
cd masterrepo
git fetch origin
git-simple-subsplit.sh path1 git@github.com:user/subrepo1.git
git-simple-subsplit.sh path2 git@github.com:user/subrepo2.git
...
```

