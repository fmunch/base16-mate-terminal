#!/usr/bin/env bash
# Base16 Rosé Pine - Mate Terminal color scheme install script
# Emilia Dunfelt &lt;sayhi@dunfelt.se&gt;

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Rosé Pine"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-rose-pine"
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
dset palette "'#191724:#e2e1e7:#ebbcba:#f6c177:#9ccfd8:#c4a7e7:#31748f:#e0def4:#555169:#eb6f92:#1f1d2e:#26233a:#6e6a86:#f0f0f3:#e5e5e5:#c5c3ce'"
dset background-color "'#191724'"
dset foreground-color "'#e0def4'"
dset bold-color "'#e0def4'"
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
