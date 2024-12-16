#!/bin/sh

available_themes=$(ls stylesheets/lfs-xsl/*.lfs.css | sed 's|stylesheets/lfs-xsl/\(.*\)\.lfs.css|\1|')

if echo "$available_themes" | grep -q -w "$1"; then
  ln -sfv "$1.lfs.css" stylesheets/lfs-xsl/lfs.css
else
  echo 'Invalid theme!' >&2
  echo
  echo 'Available themes:'
  echo "$available_themes"
  exit 1
fi
