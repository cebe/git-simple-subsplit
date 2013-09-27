#!/bin/sh
# simple and fast way of creating one-way subsplits of git repositories
#
# USAGE:
# cd mainrepo
# git-simple-subsplit.sh subpath git@github.com:user/subrepo.git [branch]

SUBPATH=$1
REMOTE=$2
if [ "$3" = "" ] ; then
	BRANCH=master
else
	BRANCH="$3"
fi

# create and checkout tracking branch
(git branch | grep "subsplit-track/$BRANCH") || git checkout -b subsplit-track/$BRANCH
git checkout subsplit-track/$BRANCH
git merge $BRANCH

git subtree split --prefix=$SUBPATH --branch=subsplit/$SUBPATH/$BRANCH --rejoin subsplit-track/$BRANCH
git push $REMOTE subsplit/$SUBPATH/$BRANCH:$BRANCH

# go back to branch
git checkout $BRANCH
