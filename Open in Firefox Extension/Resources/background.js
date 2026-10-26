// Adds "Open in Firefox" to the link context menu and a toolbar button for the
// current page; both hand the URL to the containing app's native handler,
// which opens it in Firefox.
const MENU_ID = "open-in-firefox";

function openInFirefox(url) {
  if (!url) return;
  // Safari ignores the application id and routes to the containing app.
  browser.runtime.sendNativeMessage("application.id", { url })
    .then((reply) => { if (reply && reply.error) console.error(reply.error); })
    .catch((err) => console.error("Open in Firefox failed:", err));
}

browser.contextMenus.removeAll().then(() => {
  browser.contextMenus.create({
    id: MENU_ID,
    title: "Open in Firefox",
    contexts: ["link"],
  });
});

browser.contextMenus.onClicked.addListener((info) => {
  if (info.menuItemId === MENU_ID) openInFirefox(info.linkUrl);
});

browser.browserAction.onClicked.addListener((tab) => openInFirefox(tab.url));
