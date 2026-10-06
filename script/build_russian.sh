#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

python3 script/validate_localization.py
make xcodeproj VERSION=0.5.6 CODESIGN_IDENTITY=- DEVELOPMENT_TEAM=
mkdir -p .release
xcodebuild -project WinMux.xcodeproj -scheme WinMux -configuration Release \
    -destination 'generic/platform=macOS' -archivePath .release/WinMux-ru.xcarchive \
    -derivedDataPath .release/derived ARCHS=arm64 ONLY_ACTIVE_ARCH=NO \
    CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO archive > .release/build-ru.log 2>&1 || {
    tail -100 .release/build-ru.log
    exit 1
}

app=.release/WinMux-ru.xcarchive/Products/Applications/WinMux.app
test -d "$app"
find "$app/Contents" -path '*AppBundle.bundle/ru.lproj/Localizable.strings' | grep -q .
# Xcode packages dependency bundles into the app; sign nested executable code first.
while IFS= read -r -d '' nested; do
    codesign --force --sign - "$nested"
done < <(find "$app/Contents" -depth \( -name '*.framework' -o -name '*.xpc' -o -name '*.app' \) -print0)
codesign --force --sign - --options runtime "$app"
codesign --verify --deep --strict "$app"
test "$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$app/Contents/Info.plist")" = 0.5.6
test "$(/usr/libexec/PlistBuddy -c 'Print SUEnableAutomaticChecks' "$app/Contents/Info.plist")" = false
! /usr/libexec/PlistBuddy -c 'Print SUFeedURL' "$app/Contents/Info.plist" >/dev/null 2>&1
"$app/Contents/MacOS/WinMux" --version
ditto -c -k --sequesterRsrc --keepParent "$app" .release/WinMux-0.5.6-ru.1.zip
shasum -a 256 .release/WinMux-0.5.6-ru.1.zip > .release/WinMux-0.5.6-ru.1.sha256
