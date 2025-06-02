import SwiftUI

struct RecipeListCellView: View {
    let recipe: Recipe
    let onLinkTap: (LinkType) -> Void
    
    var body: some View {
        HStack() {
            RecipeRemoteImage(urlString: recipe.photo_url_small ?? "")
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 90)
                .cornerRadius(8)
                .padding(.top, 2)
                .padding(.bottom, 2)
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .padding(.bottom)
                HStack {
                    if let ytString = recipe.youtube_url, let ytURL = URL(string: ytString) {
                        Button {
                            onLinkTap(.youtube(ytURL))
                        } label :{
                            Text("Watch")
                            
                                .font(.callout)
                                .fontWeight(.medium)
                                .frame(width: 70, height: 30, alignment: .center)
                                .foregroundColor(.blue)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .buttonStyle(.bordered)
                        .tint(.clear)
                    }
                    if let webString = recipe.source_url, let webURL = URL(string: webString) {
                        Button {
                            onLinkTap(.website(webURL))
                        } label :{
                            Text("Read")
                            
                                .font(.callout)
                                .fontWeight(.medium)
                                .frame(width: 70, height: 30, alignment: .center)
                                .foregroundColor(.blue)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .buttonStyle(.bordered)
                        .tint(.clear)
                    }
                }
            }
            .padding(.leading, 8)
        }
    }
}
