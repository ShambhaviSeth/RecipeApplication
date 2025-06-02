import XCTest
@testable import RecipeApp

final class RecipeViewModelTests: XCTestCase {

    @MainActor func testInitialState() {
        let vm = RecipeViewModel()
        XCTAssertTrue(vm.recipes.isEmpty)
        XCTAssertNil(vm.selectedRecipe)
        XCTAssertFalse(vm.isLoading)
    }

    @MainActor func testRecipesByCuisineGroupsCorrectly() {
        let vm = RecipeViewModel()
        vm.recipes = MockData.recipes
        let grouped = vm.recipesByCuisine
        XCTAssertEqual(grouped["Malaysian"]?.count, 2)
    }
}
