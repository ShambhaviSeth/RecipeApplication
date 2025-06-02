import Foundation

/// ViewModel responsible for managing the state and logic of the recipe list view.
/// Uses `@MainActor` to ensure UI updates are always made on the main thread.
@MainActor final class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?
    @Published var isLoading: Bool = false
    @Published var isEmpty: Bool = false
    @Published var errorMessage: String?
    

    /// Returns a dictionary grouping recipes by cuisine type.
    var recipesByCuisine: [String: [Recipe]] {
        Dictionary(grouping: recipes, by: { $0.cuisine })
    }


    /// Fetches recipes from the API
    func getRecipes() async {
        isLoading = true

        Task {
            do {
                // Attempt to fetch and decode recipes
                recipes = try await NetworkManager.shared.getRecipes()

                // Set empty state if no data returned
                if recipes.isEmpty {
                    isEmpty = true
                }

                isLoading = false
            } catch {
                // Handle custom recipe errors with user-friendly messages
                if let error = error as? RecipeError {
                    switch error {
                    case .invalidURL:
                        errorMessage = "Invalid URL"
                    case .decodingFailed:
                        errorMessage = "Something went wrong while loading recipes."
                    }
                }

                isLoading = false
            }
        }
    }
}
