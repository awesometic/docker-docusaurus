#!/usr/bin/env bash

msg() {
    echo -E "/* $1 */"
}

WEB_SRC_PATH="/docusaurus/website"

cd "$WEB_SRC_PATH" || (msg "Cannot enter $WEB_SRC_PATH. Won't run the yarn command to update." ; exit)

msg "Current version"
yarn docusaurus --version

msg "Now updating to the latest version..."
yarn install &
[[ "$!" -gt 0 ]]; wait "$!"

msg "Updated version"
yarn docusaurus --version

exit 0

