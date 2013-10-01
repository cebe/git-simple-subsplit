#!/bin/sh
# simple and fast way of creating one-way subsplits of git repositories
#

usage()
{
	echo ""
	echo "USAGE:"
	echo 'git-simple-subsplit.sh subpath git@github.com:user/subrepo.git [--tags "tag1 tag2 ..."] [--branches "branch1 branch2 ..."]'
	echo ""
	echo "will sync all branches and all tags by default."
	exit 1
}

if [ $# -lt 2 ] ; then
	echo "unexpected number of parameters."
	usage
fi

while [ $# -gt 0 ]; do
	opt="$1"
	shift
	case "$opt" in
		--branches) BRANCHES="$1"; shift ;;
		--tags) TAGS="$1"; shift ;;
		*)
			if [ -z "$SUBPATH" ] ; then
				SUBPATH=$opt
			else
				if [ -z "$REMOTE" ] ; then
					REMOTE=$opt
				else
					echo "unexpected number of parameters."
					usage
				fi
			fi
		;;
	esac
done

if [ -z "$BRANCHES" ]
then
	BRANCHES="$(git ls-remote origin 2>/dev/null | grep "refs/heads/" | cut -f3- -d/)"
fi

if [ -z "$TAGS" ]
then
	TAGS="$(git ls-remote origin 2>/dev/null | grep -v "\^{}" | grep "refs/tags/" | cut -f3 -d/)"
fi

echo "syncing branches..."
for BRANCH in $BRANCHES
do
	echo ""
	echo "  syncing branch $BRANCH..."
	git checkout "$BRANCH" > /dev/null

	# create and checkout tracking branch
	(git branch | grep "subsplit-track/$BRANCH") > /dev/null || git checkout -b "subsplit-track/$BRANCH" > /dev/null
	git checkout "subsplit-track/$BRANCH" > /dev/null

	# merge new changes
	git merge "$BRANCH" --no-edit > /dev/null
	if [ $? -eq 0 ] ; then

		echo "    creating/updating subtree split..."
		git subtree split --prefix="$SUBPATH" --branch="subsplit/$SUBPATH/$BRANCH" --rejoin "subsplit-track/$BRANCH"

		echo "    pushing changes to remote..."
		git push -q --force "$REMOTE" "subsplit/$SUBPATH/$BRANCH:$BRANCH"
	else
		echo "  failed to merge changes for branch $BRANCH!"
	fi
	# go back to branch
	git checkout "$BRANCH" > /dev/null
done
echo "done."

echo "syncing tags..."
for TAG in $TAGS
do
	LOCALTAG="subsplit-tags/$SUBPATH/$TAG"

	if git branch | grep "$LOCALTAG$" >/dev/null
	then
		echo "  skipping tag '${TAG}' (already synced)"
		continue
	fi

	echo "  syncing tag $TAG..."

	git branch -D "$LOCALTAG" >/dev/null 2>&1

	echo "    creating subtree split for tag $TAG"
	git subtree split --prefix="$SUBPATH" --branch="$LOCALTAG" "$TAG" > /dev/null

	if [ $? -eq 0 ]
	then
		git push -q --force "$REMOTE" "$LOCALTAG:refs/tags/$TAG"
	else
		echo "    failed to create subsplit for tag $TAG!"
	fi
done
echo "done."

