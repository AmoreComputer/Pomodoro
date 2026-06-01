import AmoreLicensing
import SwiftUI

struct ContentView: View {
    var licensing: AmoreLicensing

    var body: some View {
        switch licensing.status {
        case .valid, .gracePeriod:
            TimerView()
        default:
            LicenseView(onActivate: activate)
        }
    }
    
    private func activate(licenseKey: String) async throws {
        try await licensing.activate(licenseKey: licenseKey)
    }
}
