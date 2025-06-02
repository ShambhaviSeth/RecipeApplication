import XCTest
@testable import RecipeApp

final class NetworkManager {

    static let shared = NetworkManager()  

    private let session: URLSession
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let cache = NSCache<NSString, UIImage>()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getRecipes() async throws -> [Recipe] {
        guard let url = URL(string: baseURL) else {
            throw RecipeError.invalidURL
        }

        let (data, _) = try await session.data(from: url)

        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes
        } catch {
            throw RecipeError.decodingFailed
        }
    }

    func downloadImages(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }

        let task = session.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }

        task.resume()
    }
}


final class NetworkManagerTests: XCTestCase {
    
    var mockSession: URLSession!
    var networkManager: NetworkManager!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        networkManager = NetworkManager(session: mockSession)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        mockSession = nil
        networkManager = nil
    }
    
    func testGetRecipesReturnsDecodedRecipes() async throws {
        let json = """
        {
          "recipes": [{
            "cuisine": "Italian",
            "name": "Pizza",
            "photo_url_large": null,
            "photo_url_small": null,
            "source_url": null,
            "uuid": "123",
            "youtube_url": null
          }]
        }
        """
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), Data(json.utf8))
        }
        
        let result = try await networkManager.getRecipes()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Pizza")
    }
    
    func testGetRecipesThrowsDecodingError() async {
        let invalidJSON = "{ invalid json }"
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), Data(invalidJSON.utf8))
        }
        
        do {
            _ = try await networkManager.getRecipes()
            XCTFail("Expected decodingFailed error")
        } catch let error as RecipeError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDownloadImagesReturnsCachedImage() {
        let cacheKey = NSString(string: "https://example.com/image.png")
        let dummyImage = UIImage(systemName: "star")!
        networkManager.cache.setObject(dummyImage, forKey: cacheKey)
        
        let exp = expectation(description: "Image loaded")
        networkManager.downloadImages(fromURLString: "https://example.com/image.png") { image in
            XCTAssertNotNil(image)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testDownloadImagesDownloadsAndCachesImage() {
        let testImageData = UIImage(systemName: "star")!.pngData()!
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), testImageData)
        }
        
        let exp = expectation(description: "Image downloaded")
        networkManager.downloadImages(fromURLString: "https://example.com/image.png") { image in
            XCTAssertNotNil(image)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testGetRecipesReturnsEmptyResponse() async throws {
        let json = """
        {
            "recipes": []
        }
        """
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), Data(json.utf8))
        }
        
        let result = try await networkManager.getRecipes()
        XCTAssertEqual(result.count, 0)
        
    }
    
    func testDownloadImagesFailsGracefullyOnBadData() {
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), Data("not-an-image".utf8))
        }
        
        let exp = expectation(description: "Download failed")
        networkManager.downloadImages(fromURLString: "https://example.com/image.png") { image in
            XCTAssertNil(image)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else { return }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
