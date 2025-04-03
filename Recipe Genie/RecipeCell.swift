import SwiftUI

struct RecipeCell: View {
    
    // MARK: - Properties
    let recipe: RecipeModel
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    
    // MARK: - UI<##>
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(recipe.strMeal)
                    .font(.title3)
                    .fontWeight(.medium)
                Text(recipe.strArea)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.7), lineWidth: 1) 
        )
    }
}


