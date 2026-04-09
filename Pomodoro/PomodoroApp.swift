import AmoreLicensing
import Sparkle
import SwiftUI

@main
struct PomodoroApp: App {
    @State private var licensing = try! AmoreLicensing(
        publicKey: "hCnOengdLhytx1SBXZSloGBnPmr/gawBbb145drdkRE="
    )
    @State private var showDeactivateAlert = false

    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    var body: some Scene {
        WindowGroup {
            ContentView(licensing: licensing)
                .frame(width: 280, height: 340)
                .alert("Deactivate License?", isPresented: $showDeactivateAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Deactivate", role: .destructive) {
                        Task { try? await licensing.deactivate() }
                    }
                } message: {
                    Text("This will remove the license from this device.")
                }
        }
        .defaultSize(width: 280, height: 340)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates…") {
                    updaterController.updater.checkForUpdates()
                }
                if case .valid = licensing.status {
                    Divider()
                    Button("Deactivate License…") {
                        showDeactivateAlert = true
                    }
                }
            }
        }
    }
}
