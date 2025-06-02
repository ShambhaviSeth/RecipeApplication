import SwiftUI

/// Represents errors that can occur during recipe fetching.
enum RecipeError: Error {
    case invalidURL       // Triggered when the provided URL string is malformed
    case decodingFailed   // Triggered when JSON decoding fails
}

/// A singleton class responsible for all networking operations in the app,
/// including fetching recipes and downloading images with custom caching.
final class NetworkManager {

    static let shared = NetworkManager()
    
    /// Base API endpoint for retrieving recipe data.
    /// Toggle to other endpoints (e.g., empty or malformed) during testing.
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    // private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    // private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    
    /// In-memory cache for storing downloaded images.
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    /// Fetches and decodes recipes from the remote API using Swift Concurrency.
    func getRecipes() async throws -> [Recipe] {
        guard let url = URL(string: baseURL) else {
            throw RecipeError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch {
            throw RecipeError.decodingFailed
        }
    }

    /// Asynchronously loads an image using in-memory and disk caching.
    func loadImage(fromURLString urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        // Check in-memory cache
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Check disk cache
        let fileURL = DiskCache.filePath(for: urlString)
        if let data = try? Data(contentsOf: fileURL),
           let diskImage = UIImage(data: data) {
            cache.setObject(diskImage, forKey: cacheKey) // Cache to memory as well
            return diskImage
        }
        
        // Download image from network
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                // Save to memory and disk
                cache.setObject(image, forKey: cacheKey)
                try? data.write(to: fileURL)
                return image
            }
        } catch {
            return nil
        }
        
        return nil
    }
}
