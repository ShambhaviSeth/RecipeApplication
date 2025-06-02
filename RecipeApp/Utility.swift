import UIKit
import CryptoKit

extension String {
    /// Generates a SHA-256 hash of the string useful for creating safe and unique filenames for caching,
    func sha256() -> String {
        let hash = SHA256.hash(data: Data(self.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

/// Utility to manage manual disk caching for downloaded images
struct DiskCache {
    
    static let directory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheURL = urls[0].appendingPathComponent("RecipeImageCache")
        
        // Create the directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: cacheURL.path) {
            try? FileManager.default.createDirectory(at: cacheURL, withIntermediateDirectories: true)
        }
        
        return cacheURL
    }()
    
    static func filePath(for urlString: String) -> URL {
        let filename = urlString.sha256()
        return directory.appendingPathComponent(filename)
    }
}
