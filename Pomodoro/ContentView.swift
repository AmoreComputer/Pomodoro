import AmoreLicensing
import SwiftUI

struct ContentView: View {
    var licensing: AmoreLicensing

    var body: some View {
        switch licensing.status {
        case .valid, .gracePeriod:
            TimerView()
        default:
            LicenseView(licensing: licensing)
        }
    }
}
