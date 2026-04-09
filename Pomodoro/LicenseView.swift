import AmoreLicensing
import SwiftUI

struct LicenseView: View {
    var licensing: AmoreLicensing

    @State private var licenseKey = ""
    @State private var error: String?
    @State private var isActivating = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "timer")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Pomodoro")
                .font(.title2.bold())

            Text("Enter your license key to get started.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("License Key", text: $licenseKey)
                .textFieldStyle(.roundedBorder)

            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button("Activate") { activate() }
                .buttonStyle(.borderedProminent)
                .disabled(licenseKey.isEmpty || isActivating)

            Link("Buy License", destination: URL(string: "https://api.amore.computer/v1/checkout/4EB7B3DF-A844-4C92-AF86-021CF879C23A")!)
                .font(.subheadline)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func activate() {
        error = nil
        isActivating = true
        Task {
            defer { isActivating = false }
            do {
                try await licensing.activate(licenseKey: licenseKey)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
