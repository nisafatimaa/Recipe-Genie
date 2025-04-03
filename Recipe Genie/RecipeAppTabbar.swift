import SwiftUI

struct RecipeAppTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                FavoriteRecipesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .accentColor(Color(red: 0.094, green: 0.239, blue: 0.518))
    }
}

#Preview {
    RecipeAppTabView()
}

