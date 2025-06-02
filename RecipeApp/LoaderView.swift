import SwiftUI

/// A UIKit-based activity indicator wrapped for use in SwiftUI.
/// This uses `UIViewRepresentable` to bridge `UIActivityIndicatorView` into SwiftUI.
struct ActivityIndicator: UIViewRepresentable {

    /// Creates and configures the `UIActivityIndicatorView` instance.
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    /// Required method for `UIViewRepresentable` but not used here since no dynamic updates are needed.
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        // No dynamic updates needed
    }
}

/// A full-screen loading view that overlays a background color with a spinning activity indicator.
struct loadingView: View {
    var body: some View {
        ZStack {
            // Use the system background color and make it fill the entire screen.
            Color(.systemBackground)
                .ignoresSafeArea()

            // Centered activity indicator.
            ActivityIndicator()
        }
    }
}

