import AmoreStore
import SwiftUI

struct LicenseView: View {
    
    var onActivate: (_ licenseKey: String) async throws -> Void
    
    @State private var licenseKey = ""
    @State private var error: String?
    @State private var isActivating = false
    
    private let store = AmoreStore()
    @State private var product: Product?
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
            } else {
                content
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            defer { isLoading = false }
            let products = try? await store.products()
            self.product = products?.first
        }
    }
    
    @ViewBuilder
    private var content: some View {
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
        
        if let checkoutURL = product?.checkoutURL {
            Link("Buy License", destination: checkoutURL)
                .font(.subheadline)
        }
    }
    
    private func activate() {
        error = nil
        isActivating = true
        Task {
            defer { isActivating = false }
            do {
                try await onActivate(licenseKey)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
