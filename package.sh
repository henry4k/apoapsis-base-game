#!/bin/sh
cd "$(dirname $0)/base-game"
zip --recurse-paths \
    --compression-method deflate -8 --suffixes '.png:.ogg' \
    '../base-game.zip' '.' \
    --include '*.lua' '*.vert' '*.frag' '*.json' '*.png' '*.ogg' '*.txt'

