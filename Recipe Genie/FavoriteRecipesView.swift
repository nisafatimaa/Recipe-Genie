import SwiftUI
import SwiftData

struct FavoriteRecipesView: View {
    
    // MARK: - Properties
    @State private var favoriteRecipes: [RecipeModel] = []
    @State private var refreshID = UUID()
    @Query(sort: \FavoriteRecipe.strMeal) private var favoriteMeals: [FavoriteRecipe] = []
    @Environment(\.modelContext) private var context
    
    // MARK: - UI
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.094, green: 0.239, blue: 0.518).ignoresSafeArea(edges: .top)
                
                VStack {
                    if favoriteRecipes.isEmpty {
                        Text("No favorite recipes yet!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                Color.clear.frame(height: 10)
                                
                                ForEach(favoriteRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        RecipeCell(recipe: recipe, isFavorite: true) {
                                            toggleFavorite(for: recipe)
                                        }
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .id(refreshID)
                    }
                }
                .onAppear {
                    refreshID = UUID()
                    loadFavoriteRecipes()
                    
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundColor = UIColor.white
                    appearance.titleTextAttributes = [
                        .foregroundColor: UIColor(red: 0.094, green: 0.239, blue: 0.518, alpha: 1),
                        .font: UIFont.systemFont(ofSize: 22, weight: .bold)
                    ]
                    
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            .navigationTitle("Favorite Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Load Favorite Recipes from SwiftData
    private func loadFavoriteRecipes() {
        // Mapping the FavoriteRecipe objects to RecipeModel for display purposes
        favoriteRecipes = favoriteMeals.map { favorite in
            RecipeModel(
                idMeal: favorite.idMeal,
                strMeal: favorite.strMeal,
                strInstructions: favorite.strInstructions,
                strMealThumb: favorite.strMealThumb,
                strArea: favorite.strArea,
                strIngredient1: favorite.ingredients.count > 0 ? favorite.ingredients[0] : nil,
                strIngredient2: favorite.ingredients.count > 1 ? favorite.ingredients[1] : nil,
                strIngredient3: favorite.ingredients.count > 2 ? favorite.ingredients[2] : nil,
                strIngredient4: favorite.ingredients.count > 3 ? favorite.ingredients[3] : nil,
                strIngredient5: favorite.ingredients.count > 4 ? favorite.ingredients[4] : nil,
                strIngredient6: favorite.ingredients.count > 5 ? favorite.ingredients[5] : nil,
                strIngredient7: favorite.ingredients.count > 6 ? favorite.ingredients[6] : nil,
                strIngredient8: favorite.ingredients.count > 7 ? favorite.ingredients[7] : nil,
                strIngredient9: favorite.ingredients.count > 8 ? favorite.ingredients[8] : nil,
                strIngredient10: favorite.ingredients.count > 9 ? favorite.ingredients[9] : nil,
                strIngredient11: favorite.ingredients.count > 10 ? favorite.ingredients[10] : nil,
                strIngredient12: favorite.ingredients.count > 11 ? favorite.ingredients[11] : nil,
                strIngredient13: favorite.ingredients.count > 12 ? favorite.ingredients[12] : nil,
                strIngredient14: favorite.ingredients.count > 13 ? favorite.ingredients[13] : nil,
                strIngredient15: favorite.ingredients.count > 14 ? favorite.ingredients[14] : nil,
                strIngredient16: favorite.ingredients.count > 15 ? favorite.ingredients[15] : nil,
                strIngredient17: favorite.ingredients.count > 16 ? favorite.ingredients[16] : nil,
                strIngredient18: favorite.ingredients.count > 17 ? favorite.ingredients[17] : nil,
                strIngredient19: favorite.ingredients.count > 18 ? favorite.ingredients[18] : nil,
                strIngredient20: favorite.ingredients.count > 19 ? favorite.ingredients[19] : nil,
                strMeasure1: nil,
                strMeasure2: nil,
                strMeasure3: nil,
                strMeasure4: nil,
                strMeasure5: nil,
                strMeasure6: nil,
                strMeasure7: nil,
                strMeasure8: nil,
                strMeasure9: nil,
                strMeasure10: nil,
                strMeasure11: nil,
                strMeasure12: nil,
                strMeasure13: nil,
                strMeasure14: nil,
                strMeasure15: nil,
                strMeasure16: nil,
                strMeasure17: nil,
                strMeasure18: nil,
                strMeasure19: nil,
                strMeasure20: nil
            )
        }
    }
    
    // MARK: - Favorite Toggle Functionality
    func toggleFavorite(for recipe: RecipeModel) {
        if let index = favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
            favoriteRecipes.remove(at: index)
            if let existingFavorite = favoriteMeals.first(where: { $0.idMeal == recipe.id }) {
                context.delete(existingFavorite)
            }
        } else {
            favoriteRecipes.append(recipe)
            let favoriteRecipe = FavoriteRecipe(from: recipe)
            context.insert(favoriteRecipe)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save favorite recipe: \(error)")
        }
    }
}

#Preview {
    FavoriteRecipesView()
}
