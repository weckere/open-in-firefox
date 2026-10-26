First release of **Open in Firefox**, a small Safari extension for macOS that sends links to Firefox.

### What it's for
It was built for a home network whose DNS blocks tracking domains with the StevenBlack hosts list. Marketing emails wrap their links in click-tracking redirects, such as Amazon SES's `awstrack.me`. On that network those links fail in Safari with "Safari Can't Find the Server". Firefox with uBlock Origin opens them anyway, because the *uBlock filters – Privacy* list has a `urlskip` rule that pulls out the real destination and skips the tracker. This extension gives Safari a one-click way to send such a link to Firefox.

### Features
- **Right-click a link ▸ Open in Firefox**
- **Toolbar button**: opens the current page's address in Firefox, including the failed address on Safari's "can't find the server" page.

### Install
1. Unzip and move **Open in Firefox.app** to `/Applications`, then open it once.
2. Safari ▸ Settings ▸ Extensions: enable **Open in Firefox**.
3. Safari ▸ Settings ▸ Websites ▸ Open in Firefox: set **When visiting other websites** to **Allow**. The right-click item only appears on sites the extension has access to.

Signed with Developer ID and notarized by Apple. Requires macOS 13+ and Firefox.
