//
//  SafariWebExtensionHandler.swift
//  Open in Firefox Extension
//
//  Receives {url} from background.js via browser.runtime.sendNativeMessage
//  and opens that URL in Firefox.
//

import AppKit
import SafariServices
import os.log

let firefoxBundleIdentifier = "org.mozilla.firefox"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem
        let message = request?.userInfo?[SFExtensionMessageKey] as? [String: Any]

        guard let urlString = message?["url"] as? String,
              let url = URL(string: urlString),
              ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            reply(context, ["error": "not an http(s) link"])
            return
        }

        guard let firefox = NSWorkspace.shared.urlForApplication(withBundleIdentifier: firefoxBundleIdentifier) else {
            os_log(.error, "Firefox is not installed")
            reply(context, ["error": "Firefox is not installed"])
            return
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true
        NSWorkspace.shared.open([url], withApplicationAt: firefox, configuration: configuration) { _, error in
            if let error = error {
                os_log(.error, "Opening %{public}@ in Firefox failed: %{public}@", url.absoluteString, error.localizedDescription)
                self.reply(context, ["error": error.localizedDescription])
            } else {
                self.reply(context, ["ok": true])
            }
        }
    }

    private func reply(_ context: NSExtensionContext, _ body: [String: Any]) {
        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: body]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
