import Foundation

/// Localizes application-owned text; keep window titles and config values intact.
func L(_ key: String, bundle: Bundle = .module) -> String {
    bundle.localizedString(forKey: key, value: key, table: nil)
}

func LF(_ key: String, _ arguments: CVarArg..., bundle: Bundle = .module) -> String {
    String(format: L(key, bundle: bundle), locale: Locale.current, arguments: arguments)
}
