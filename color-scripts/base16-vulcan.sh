#!/usr/bin/env bash
# Base16 vulcan - Mate Terminal color scheme install script
# Andrey Varfolomeev

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 vulcan"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-vulcan"
[[ -z "$DCONFTOOL" ]] && DCONFTOOL=dconf
[[ -z "$BASE_KEY" ]] && BASE_KEY=/org/mate/terminal

PROFILE_KEY="$BASE_KEY/profiles/$PROFILE_SLUG"
DEFAULT_SLUG=$("$DCONFTOOL" read "$BASE_KEY/global/default-profile" | tr -d \')
DEFAULT_KEY="$BASE_KEY/profiles/$DEFAULT_SLUG"

dcopy() {
  local from="$1"; shift
  local to="$1"; shift

  "$DCONFTOOL" dump "$from/" | "$DCONFTOOL" load "$to/"
}

dset() {
  local key="$1"; shift
  local val="$1"; shift

  "$DCONFTOOL" write "$PROFILE_KEY/$key" "$val"
}

glist_append() {
  local key="$1"; shift
  local val="$1"; shift

  local entries="$(
    {
      "$DCONFTOOL" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
      echo "'$val'"
    } | head -c-1 | tr "\n" ,
  )"

  "$DCONFTOOL" write "$key" "[$entries]"
}

if [ -n "$DEFAULT_SLUG" ]; then
  dcopy "$DEFAULT_KEY" "$PROFILE_KEY"
fi

dset visible-name "'$PROFILE_NAME'"
dset palette "'#041523:#818591:#977d7c:#adb4b9:#977d7c:#9198a3:#977d7c:#5b778c:#7a5759:#9198a3:#122339:#003552:#6b6977:#333238:#977d7c:#214d68'"
dset background-color "'#041523'"
dset foreground-color "'#5b778c'"
dset bold-color "'#5b778c'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"

glist_append "$BASE_KEY/global/profile-list" "$PROFILE_SLUG"

unset PROFILE_NAME
unset PROFILE_SLUG
unset DCONFTOOL
unset BASE_KEY
unset PROFILE_KEY
unset DEFAULT_SLUG
unset DEFAULT_KEY
