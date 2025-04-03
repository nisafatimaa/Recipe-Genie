import SwiftUI
import SwiftData

struct RecipeListView: View {
    
    // MARK: - Properties
    let query: String
    @State private var recipes: [RecipeModel] = []
    @State private var filteredRecipesList: [RecipeModel] = []
    @Query(sort: \FavoriteRecipe.strMeal) private var favoriteMeals: [FavoriteRecipe] = []
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAllergies: [String] = [] {
        didSet { updateFilteredRecipes() }
    }

    // MARK: - UI
    var body: some View {
        NavigationStack {
            VStack {
                Color.clear.frame(height: 7)
             
                if !selectedAllergies.isEmpty {
                    allergyFilterView()
                }
           
                if filteredRecipesList.isEmpty {
                    Text("No recipes found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    recipeListView()
                }
            }
            .onAppear {
                loadRecipes()
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar { navigationToolbar() }
            .toolbarBackground(Color(red: 0.094, green: 0.239, blue: 0.518), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(.white)
        }
    }
    
    // MARK: - Allergy Filter View
    @ViewBuilder
    private func allergyFilterView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(selectedAllergies, id: \.self) { allergy in
                    HStack {
                        Text(allergy)
                            .font(.title3)
                        
                        Button(action: {
                            selectedAllergies.removeAll { $0 == allergy }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                        .padding(2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(30)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Recipe List View
    @ViewBuilder
    private func recipeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                       ForEach(filteredRecipesList) { recipe in
                           NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                               RecipeCell(
                                   recipe: recipe,
                                   isFavorite: favoriteMeals.contains { $0.idMeal == recipe.id }
                               ) {
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
    }

    // MARK: - Navigation Toolbar
    @ToolbarContentBuilder
    private func navigationToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        
        ToolbarItem(placement: .principal) {
            Text("Recipes")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: AddAllergyView(selectedAllergies: $selectedAllergies)) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Filtering Recipes Based on Allergies
    private func updateFilteredRecipes() {
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = recipes.filter { recipe in
                !selectedAllergies.contains { allergy in
                    recipe.getIngredients().contains { $0.localizedCaseInsensitiveContains(allergy) }
                }
            }
            DispatchQueue.main.async {
                self.filteredRecipesList = filtered
            }
        }
    }

    // MARK: - Load Recipes
    private func loadRecipes() {
        RecipeAPIService.fetchRecipes(query: query) { fetchedRecipes in
            DispatchQueue.main.async {
                self.recipes = fetchedRecipes
                self.updateFilteredRecipes()
            }
        }
    }

    // MARK: - Favorite Recipes Functionality
    private func toggleFavorite(for recipe: RecipeModel) {
          if let existingFavorite = favoriteMeals.first(where: { $0.idMeal == recipe.id }) {
              context.delete(existingFavorite)
          } else {
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
