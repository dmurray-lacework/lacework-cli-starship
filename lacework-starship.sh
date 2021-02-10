#!/bin/bash

readonly cached_version="$HOME/.config/lacework/cache_version"

main() {
  if [ -f $cached_version ]; then
    # Cached Version file exists
    echo $(readCached)
  else
    # File exists, read
    echo $(cacheVersion)
  fi
}

cacheVersion() {
  echo $(laceworkVersion) > $cached_version
}

laceworkVersion() {
  echo $(lacework version) | cut -d " " -f2
}

readCached(){
  refreshCache
  cat $cached_version
}

# Update Cache if older than 5 days
refreshCache() {
  five_days_ago=$(date -d 'now - 5 days' +%s)
  file_time=$(date -r "$cached_version" +%s)

  if (( file_time <= five_days_ago )); then
    # Update Cache
    cacheVersion
  fi
}

main "$@" || exit 99

