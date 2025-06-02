import XCTest
@testable import RecipeApp

final class LinkTypeTests: XCTestCase {

    func testYouTubeEmbedURLValid() {
        let url = URL(string: "https://www.youtube.com/watch?v=test123")!
        let result = LinkType.youtubeEmbedURL(from: url)
        XCTAssertEqual(result?.absoluteString, "https://www.youtube.com/embed/test123?playsinline=1")
    }

    func testYouTubeEmbedURLInvalid() {
        let url = URL(string: "https://www.youtube.com/watch")!
        XCTAssertNil(LinkType.youtubeEmbedURL(from: url))
    }

    func testIDGeneration() {
        let yt = LinkType.youtube(URL(string: "https://youtube.com?v=abc")!)
        XCTAssertTrue(yt.id.starts(with: "youtube-"))
        let web = LinkType.website(URL(string: "https://site.com")!)
        XCTAssertTrue(web.id.starts(with: "website-"))
    }
}
