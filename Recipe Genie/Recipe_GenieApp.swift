import SwiftUI
import SwiftData

@main
struct Recipe_GenieApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeAppTabView()
        }
        .modelContainer(for: FavoriteRecipe.self)
    }
}
