#!/bin/sh
prevdir=$(pwd)

DIR=${1:-'.'}
COMPONENT=${2:-$(basename $DIR)}
UPSTREAM=${3:-'@{u}'} # An upstream branch can be passed explicitly

cd $DIR

git fetch > /dev/null
LOCAL=$( git rev-parse @)
REMOTE=$(git rev-parse   "$UPSTREAM")
BASE=$(git  merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
	echo "Up to date"
elif [ $LOCAL = $BASE ]; then
	$HOME/bin/letters/post_letter.sh "$HOME/.letters/$COMPONENT" "$COMPONENT" "cd $DIR && git pull"
	echo "Need to pull"
elif [ $REMOTE = $BASE ]; then
	echo "Need to push"
else
	echo "Diverged"
fi

cd $prevdir
