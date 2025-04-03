import SwiftUI

struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct HomeView: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    @State private var navigateToSearch = false
    @State private var showAlert = false
    
    let allRecipes = [
        Recipe(name: "Pizza", imageName: "pizza"),
        Recipe(name: "Pasta", imageName: "pasta"),
        Recipe(name: "Cake", imageName: "cake"),
        Recipe(name: "Chicken", imageName: "chicken"),
        Recipe(name: "Salad", imageName: "salad"),
        Recipe(name: "Steak", imageName: "beef"),
        Recipe(name: "Tomato Soup", imageName: "soup")
    ]
    
    var randomRecipes: [Recipe] {
        allRecipes.shuffled().prefix(8).map { $0 }
    }
        
        // MARK: - UI
        var body: some View {
            NavigationStack {
                ZStack {
                    Color(red: 0.094, green: 0.239, blue: 0.518).ignoresSafeArea(edges: .top)
                    
                    VStack(spacing: 40) {
                        VStack {
                            Image("chefHatLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 170, height: 120)
                            
                            Text("Recipe Genie")
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 10)
                                
                                TextField("Search for recipes", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .frame(height: 48)
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(22)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 20)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Example Recipes")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.leading)
                                    
                                    ForEach(randomRecipes) { recipe in
                                        Button(action: {
                                            searchText = recipe.name
                                        }) {
                                            HStack {
                                                Image(recipe.imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                
                                                Text(recipe.name)
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                            }
                                            .padding(6)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(15)
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: RecipeListView(query: searchText)) {
                                Text("Search")
                                    .frame(width: 150, height: 50)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(23)
                                    .padding(.bottom, 50)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                            .padding(.bottom, 5)
                            .disabled(searchText.isEmpty)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Empty Search"),
                                      message: Text("Please enter a recipe name."),
                                      dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                }
            }
        }
    }

    #Preview {
        HomeView()
    }

