#!/bin/bash

#I don't know why Plex can't just have a custom package source or distribute an updated package directly
#So instead of running a shell script on the NAS to manually update the package, I want a feed.

PLEX_FEED_URL="https://plex.tv/api/downloads/5.json"

PLEX_JSON=$(curl -s "${PLEX_FEED_URL}")

version=$(echo "$PLEX_JSON" | jq -r '.nas."Synology (DSM 7)".version')
link=$(echo "$PLEX_JSON" | jq -r '.nas."Synology (DSM 7)".releases[1] | .url')
sha256=$(echo "$PLEX_JSON" | jq -r '.nas."Synology (DSM 7)".releases[1] | .checksum')

wget -q "$link" -O $version.spk

md5=$(md5sum $version.spk)
size=$(du -k "$version.spk" | cut -f1)

rm $version.spk


echo "$version"
echo "$link"
echo "$sha256"
echo "$md5"
echo "$size"

jinja2 feed.j2 -D version=$version -D link=$link -D sha256=$sha256 -D md5=$md5 -D size=$size > feed.json
