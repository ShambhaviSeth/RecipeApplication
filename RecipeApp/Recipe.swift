import Foundation

/// Represents a single recipe item fetched from the API.
struct Recipe: Decodable, Identifiable {
    // `id` allows use in SwiftUI Lists; it maps directly to the `uuid` provided by the API.
    var id: String { uuid }

    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let source_url: String?
    let uuid: String
    let youtube_url: String?
}

/// Represents the top-level JSON response containing a list of recipes.
struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

/// Enum used for handling link taps in the UI (YouTube or Website).
enum LinkType: Identifiable {
    case youtube(URL)
    case website(URL)

    var id: String {
        switch self {
        case .youtube(let url): return "youtube-\(url.absoluteString)"
        case .website(let url): return "website-\(url.absoluteString)"
        }
    }
}

extension LinkType {
    /// Converts a standard YouTube video URL to an embeddable format for use in WebView.
    static func youtubeEmbedURL(from url: URL) -> URL? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let videoID = queryItems.first(where: { $0.name == "v" })?.value
        else {
            return nil
        }

        return URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1")
    }
}

/// Provides mock recipe data useful for previews and testing without hitting the API.
struct MockData {
    static let sampleRecipe = Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        photo_url_large: "",
        photo_url_small: "",
        source_url: "",
        uuid: "1",
        youtube_url: "https://www.youtube.com/watch?v=qsk_At_gjv0"
    )

    static let recipes = [sampleRecipe, sampleRecipe]
}
