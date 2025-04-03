import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    
    let recipe: RecipeModel
    @State private var isFavorite: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \FavoriteRecipe.strMeal) private var favoriteMeals: [FavoriteRecipe] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 1) {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 250)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 250)
                        }
                        
                        Text(recipe.strMeal)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.6))
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Spacer()
                            Text("Cuisine: \(recipe.strArea)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(red: 0.094, green: 0.239, blue: 0.518))
                                .cornerRadius(10)
                            Spacer()
                        }
                        
                        IngredientsView(ingredients: recipe.getIngredients())
                        InstructionsView(instructions: recipe.strInstructions)
                    }
                    .padding(20)
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.094, green: 0.239, blue: 0.518), for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Recipe Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 26, height: 24)
                            .foregroundColor(isFavorite ? .red : .white)
                    }
                }
            }
            .onAppear {
                checkIfFavorite()
            }
        }
    }
    
    // MARK: - Check if the recipe is already a favorite
    private func checkIfFavorite() {
        isFavorite = favoriteMeals.contains(where: { $0.idMeal == recipe.idMeal })
    }
    
    // MARK: - Toggle Favorite Recipes Functionality
    func toggleFavorite() {
        if isFavorite {
            // Remove from favorites
            if let favorite = favoriteMeals.first(where: { $0.idMeal == recipe.idMeal }) {
                context.delete(favorite)
                isFavorite = false
            }
        } else {
            // Add to favorites
            let newFavorite = FavoriteRecipe(from: recipe)
            context.insert(newFavorite)
            isFavorite = true
        }
        
        // Save the changes to SwiftData
        do {
            try context.save()
        } catch {
            print("Failed to save favorite recipe: \(error)")
        }
    }
}

#Preview {
    RecipeDetailView(recipe: RecipeModel(
        idMeal: "1234",
        strMeal: "Delicious Pasta",
        strInstructions: "Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve.Boil pasta. Add sauce. Mix well and serve. Boil pasta. Add sauce. Mix well and serve.",
        strMealThumb: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg",
        strArea: "Italian",
        strIngredient1: "Pasta",
        strIngredient2: "Tomato Sauce",
        strIngredient3: "Garlic",
        strIngredient4: "Garlic",
        strIngredient5: "Garlic",
        strIngredient6: "",
        strIngredient7: "",
        strIngredient8: "",
        strIngredient9: "",
        strIngredient10: "",
        strIngredient11: "",
        strIngredient12: "",
        strIngredient13: "",
        strIngredient14: "",
        strIngredient15: "",
        strIngredient16: "",
        strIngredient17: "",
        strIngredient18: "",
        strIngredient19: "",
        strIngredient20: "",
        strMeasure1: "200g",
        strMeasure2: "1 cup",
        strMeasure3: "2 cloves",
        strMeasure4: "",
        strMeasure5: "",
        strMeasure6: "",
        strMeasure7: "",
        strMeasure8: "",
        strMeasure9: "",
        strMeasure10: "",
        strMeasure11: "",
        strMeasure12: "",
        strMeasure13: "",
        strMeasure14: "",
        strMeasure15: "",
        strMeasure16: "",
        strMeasure17: "",
        strMeasure18: "",
        strMeasure19: "",
        strMeasure20: ""
    ))
}

