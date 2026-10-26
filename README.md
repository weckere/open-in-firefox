# Open in Firefox

A tiny Safari extension for macOS that sends links to Firefox:

- **Right-click a link ▸ Open in Firefox** opens that link in Firefox.
- **Click the toolbar button** to open the current page's address in Firefox. This works even
  when Safari is showing an error page, such as "Safari Can't Find the Server".

## Why it exists

It was made for a home network whose DNS blocks ad and tracking domains with a hosts blocklist
([StevenBlack/hosts](https://github.com/StevenBlack/hosts)). Marketing emails often wrap every
link in a click-tracking redirect. For example, Amazon SES links look like
`https://….awstrack.me/L0/https:%2F%2Fexample.com%2Fpage/…`. The tracking domain is on the
blocklist, so in Safari those links fail with "can't find the server" and never reach the real
page.

Firefox with [uBlock Origin](https://github.com/gorhill/uBlock) handles them: the *uBlock
filters – Privacy* list has a `urlskip` rule that pulls the real destination out of the tracking
link and goes straight there, without contacting the tracker. Safari has no equivalent, so this
extension gives Safari users a one-click way to hand such a link to Firefox.

## Install

1. Download `OpenInFirefox-<version>.zip` from the [latest release](../../releases/latest), unzip it,
   and move **Open in Firefox.app** to `/Applications`.
2. Open the app once, then quit it.
3. Safari ▸ Settings ▸ Extensions: check **Open in Firefox**.
4. Safari ▸ Settings ▸ Websites ▸ Open in Firefox: set **When visiting other websites** to
   **Allow**. Safari only shows an extension's right-click items on sites it has access to.
   The extension doesn't read any page. It only receives the URL when you use it.

It requires macOS 13 or later and Firefox (`org.mozilla.firefox`). For tracking links, Firefox
also needs uBlock Origin with *uBlock filters – Privacy* enabled.

## How it works

- `Open in Firefox Extension/Resources/background.js` adds the link context-menu item and the
  toolbar button, and sends the URL to the containing app through
  `browser.runtime.sendNativeMessage`.
- `Open in Firefox Extension/SafariWebExtensionHandler.swift` receives `{url}`, accepts only
  `http`/`https` URLs, and opens them in Firefox with `NSWorkspace`.

## Building

`./build.sh` builds a Developer ID–signed Release app into `build/`. `./build.sh notarize` also
notarizes it, staples the ticket, and writes `build/Open in Firefox.zip`. The notarytool keychain
profile comes from `$NOTARY_PROFILE`. The team ID and bundle identifiers are set for the
author's account, so change them in `build.sh` and the Xcode project to build under your own.

## License

[MIT](LICENSE)
