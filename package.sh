#!/bin/sh
cd "$(dirname $0)/example"
zip --recurse-paths \
    --compression-method deflate -8 --suffixes '.png:.ogg' \
    '../example.zip' '.' \
    --include '*.lua' '*.vert' '*.frag' '*.json' '*.png' '*.ogg' '*.txt'

