#!/bin/sh
# Makes a 320px JPEG for every clip that has none yet. Clips are mounted read-only; thumbs mirror the folder layout.
while true; do
  find /clips -type f -name '*.MP4' -mmin +1 -not -path '*/_logs/*' | while read -r f; do
    rel=${f#/clips/}; out=/thumbs/${rel%.MP4}.jpg
    [ -s "$out" ] && continue
    mkdir -p "$(dirname "$out")"
    ffmpeg -nostdin -loglevel error -y -ss 3 -i "$f" -frames:v 1 -vf scale=320:-2 -q:v 5 "$out" 2>/dev/null \
      || ffmpeg -nostdin -loglevel error -y -i "$f" -frames:v 1 -vf scale=320:-2 -q:v 5 "$out" 2>/dev/null \
      || { echo "thumb failed: $rel"; rm -f "$out"; }
  done
  sleep 120
done
