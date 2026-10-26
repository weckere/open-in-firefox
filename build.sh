#!/usr/bin/env bash
# Build "Open in Firefox" signed with Developer ID.
#   ./build.sh            build only
#   ./build.sh notarize   build, notarize, staple, and zip for copying
# Notarizes with the notarytool keychain profile in $NOTARY_PROFILE (default "robstation";
# profiles are per Apple ID + team, so any app from team 43PA534BM6 can share one).
set -euo pipefail
cd "$(dirname "$0")"
NOTARY_PROFILE="${NOTARY_PROFILE:-robstation}"

xcodebuild -project "Open in Firefox.xcodeproj" -scheme "Open in Firefox" -configuration Release \
  -derivedDataPath build \
  CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="Developer ID Application" DEVELOPMENT_TEAM=43PA534BM6 \
  PROVISIONING_PROFILE_SPECIFIER= OTHER_CODE_SIGN_FLAGS=--timestamp \
  CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO CODE_SIGN_ENTITLEMENTS="$PWD/OpenInFirefox.entitlements" \
  clean build | grep -E 'error:|BUILD'

APP="build/Build/Products/Release/Open in Firefox.app"
codesign --verify --deep --strict "$APP"
echo "Built: $APP"

if [[ "${1:-}" == "notarize" ]]; then
  ditto -c -k --keepParent "$APP" build/OpenInFirefox-submit.zip
  xcrun notarytool submit build/OpenInFirefox-submit.zip --keychain-profile "$NOTARY_PROFILE" --wait --timeout 1h
  xcrun stapler staple "$APP"
  ditto -c -k --keepParent "$APP" "build/Open in Firefox.zip"
  echo "Notarized: build/Open in Firefox.zip"
fi
