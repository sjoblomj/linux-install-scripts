#!/bin/sh
prevdir=$(pwd)

DIR=${1:-'.'}
COMPONENT=${2:-$(basename "$DIR")}
UPSTREAM=${3:-'@{u}'} # An upstream branch can be passed explicitly

cd "$DIR" || exit 1

git fetch > /dev/null
LOCAL=$( git rev-parse @)
REMOTE=$(git rev-parse   "$UPSTREAM")
BASE=$(git  merge-base @ "$UPSTREAM")

if [ "$LOCAL" = "$REMOTE" ]; then
	echo "Up to date"
elif [ "$LOCAL" = "$BASE" ]; then
    cmd=""
    if [ ! -f "$HOME/.letters/update_instructions/$COMPONENT" ]; then
        cmd="cd $DIR && git pull && cd -"
    fi
	"$HOME"/bin/letters/post_letter.sh "$HOME/.letters/$COMPONENT" "$COMPONENT" "$cmd"
	echo "Need to pull"
elif [ "$REMOTE" = "$BASE" ]; then
	echo "Need to push"
else
	echo "Diverged"
fi

cd "$prevdir" || exit 1
