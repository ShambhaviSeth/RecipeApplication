import SwiftUI

/// Responsible for asynchronously loading a UIImage and converting it into a SwiftUI Image
final class ImageLoader: ObservableObject {
    @Published var image: Image? = nil

    func load(fromURLString urlString: String) {
        Task {
            if let uiImage = await NetworkManager.shared.loadImage(fromURLString: urlString) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }
    }
}

struct RemoteImage: View {
    var image: Image?

    var body: some View {
        image?.resizable() ?? Image("recipe-placeholder").resizable()
    }
}


struct RecipeRemoteImage: View {
    @StateObject var imageLoader = ImageLoader()
    let urlString: String                        

    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear {
                imageLoader.load(fromURLString: urlString)
            }
    }
}
