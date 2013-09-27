git-simple-subsplit
===================

A git subtree/subsplit script for quickly creating one-way subsplit of repositories. (use for composer packages)

A bit ugly because it pollutes the checked out repos history which should never be pushed back to upstream.

Usage
-----

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

TODO: add tags and other branches
