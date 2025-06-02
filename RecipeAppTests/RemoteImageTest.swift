
import XCTest
@testable import RecipeApp

final class ImageLoaderTests: XCTestCase {
    
    func testImageLoaderReturnsNilForInvalidURL() {
        let loader = ImageLoader()
        let expectation = self.expectation(description: "Image load complete")
        
        loader.load(fromURLString: "invalid-url")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(loader.image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
