import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var activeLinkType: LinkType? = nil

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.recipesByCuisine.sorted(by: { $0.key < $1.key }), id: \.key) { cuisine, recipes in
                        Section(header: Text(cuisine)
                            .foregroundStyle(Color.blue)
                            .font(.title3)
                            .fontWeight(.bold)) {
                                ForEach(recipes) { recipe in
                                    RecipeListCellView(recipe: recipe) { link in
                                        activeLinkType = link
                                    }
                                }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Recipes")
                .refreshable {
                    await viewModel.getRecipes()
                }
            }
            .task {
                await viewModel.getRecipes()
            }
            .fullScreenCover(item: $activeLinkType) { type in
                switch type {
                case .website(let url):
                    WebViewScreen(url: url, dismiss: {
                        activeLinkType = nil
                    })

                case .youtube(let url):
                    if let embedURL = LinkType.youtubeEmbedURL(from: url) {
                        WebViewScreen(url: embedURL, dismiss: {
                            activeLinkType = nil
                        })
                    } else {
                        Text("Invalid YouTube URL")
                    }
                }
            }

            if viewModel.isLoading {
                loadingView()
            }

            if viewModel.isEmpty {
                VStack {
                    Text("No recipes available at the moment")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            }
            if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    RecipeListView()
}
