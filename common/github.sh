#!/bin/bash

download_latest_release_from_github() {
    local githubrepo="$1"
    local extract_path="$2"

    local depth=0
    local path=""
    local latestreleasedata=""
    local latestreleasename=""
    local tmpfile=""

    latestreleasedata=$(curl -sL \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$githubrepo/releases" | \
      jq '[.[] | select(.prerelease == false)][0] | {name, tarball_url}')

    tmpfile=$(mktemp)
    latestreleasename=$(echo "$latestreleasedata" | jq -r '.name')
    path="$extract_path/$latestreleasename"

    mkdir -p "$path"
    curl -L $(echo "$latestreleasedata" | jq -r '.tarball_url') -o "$tmpfile"
    depth=$(tar tf "$tmpfile" | awk -F/ '{ if($0 != "") print $0 }' | grep -o -n '/' | cut -d : -f 1 | uniq -c | awk '{print $1}' | sort | uniq | head -n 1)
    if [ -z "$depth" ]; then
        depth=0;
    fi
    tar xvf "$tmpfile" --directory="$path" --strip-components="$depth" &> /dev/null
    rm "$tmpfile"
    echo "$path"
}
