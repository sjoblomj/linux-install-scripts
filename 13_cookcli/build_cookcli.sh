#!/bin/bash
set -e
prevdir=$(pwd)
cd "$HOME"/bin/cookcli || exit 1
git pull
cargo build --release
cd ui || exit 1
npm install
npm run build
cd "$prevdir" || exit 1
