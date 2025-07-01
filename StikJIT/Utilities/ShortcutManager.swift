import UIKit

/// Provides helper functions for installing and running the optional cellular-toggle shortcut.
enum ShortcutManager {
    /// The exact name the shortcut must have so we can run it.
    private static let shortcutName = "StikDebug Cellular Toggle"
    
    /// Direct-import URL – opens Shortcuts and jumps straight to the "Add Shortcut" sheet.
    private static let installLink = "shortcuts://import-shortcut?url=https%3A%2F%2Fwww.icloud.com%2Fshortcuts%2F521c6f152fa049e6b1ba0e1c855794fc"
    
    /// Launches the Shortcut (if installed). Does nothing if the URL cannot be formed.
    static func runToggleCellularShortcut() {
        guard let encodedName = shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "shortcuts://run-shortcut?name=\(encodedName)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// Opens the installation page so the user can add the shortcut.
    static func openInstallPage() {
        guard let url = URL(string: installLink) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
} 