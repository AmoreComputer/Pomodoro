import Sparkle
import SwiftUI

@main
struct PomodoroApp: App {
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates…") {
                    updaterController.updater.checkForUpdates()
                }
            }
        }
    }
}
