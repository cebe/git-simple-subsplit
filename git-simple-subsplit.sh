#!/bin/sh
# simple and fast way of creating one-way subsplits of git repositories
#
# a bit ugly because it pollutes the checked out repos history which should never be pushed back to upstream
#
# USAGE:
# cd repo
# git-simple-subsplit.sh path git@github.com:user/subrepo.git

SUBPATH=$1
REMOTE=$2
BRANCH=master

git subtree split --prefix=$SUBPATH --branch=subsplit/$SUBPATH/$BRANCH --rejoin $BRANCH
git push $REMOTE subsplit/$SUBPATH/$BRANCH:$BRANCH

