import SwiftUI

struct ShortcutConfigurationReferenceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("Configuration Reference"))
                    .font(.headline)
                Text(L("Use Configuration to edit the complete winmux.toml file. The settings panes cover the everyday options; this reference lists the remaining advanced sections."))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                ReferenceSection(L("Keyboard")) {
                    ReferenceRow("[key-mapping]", L("Keyboard layout preset and custom key notation mappings."))
                    ReferenceRow("[mode.<name>.binding]", L("Chord and sequence shortcuts for any mode."))
                    ReferenceRow("[mode.<name>.binding-tap]", L("Tap-only shortcut bindings."))
                }
                ReferenceSection(L("Rules and integrations")) {
                    ReferenceRow("[exec]", L("Inherited environment and explicit environment variables for commands."))
                    ReferenceRow("[workspace-to-monitor-force-assignment]", L("Workspace-to-display assignments."))
                    ReferenceRow("on-window-detected", L("Window matching rules and commands to run."))
                    ReferenceRow("on-focus-changed", L("Commands that run after the focused window changes."))
                    ReferenceRow("on-focused-monitor-changed", L("Commands that run after the active display changes."))
                    ReferenceRow("on-mode-changed", L("Commands that run after switching modes."))
                }
                ReferenceSection(L("Named sidebar items")) {
                    ReferenceRow("workspace-labels", L("Override visible workspace names."))
                    ReferenceRow("project-labels", L("Override visible project names."))
                    ReferenceRow("project-colors", L("Assign project colors using #RRGGBB values."))
                }
                Text(L("The Configuration editor validates the entire file before saving and shows parser errors inline."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    }
}

private struct ReferenceSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            content
        }
    }
}

private struct ReferenceRow: View {
    let key: String
    let description: String

    init(_ key: String, _ description: String) {
        self.key = key
        self.description = description
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(key)
                .font(.system(size: 12, design: .monospaced))
                .frame(width: 255, alignment: .leading)
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
