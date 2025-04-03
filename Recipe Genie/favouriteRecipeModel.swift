import SwiftUI
import SwiftData

@Model
class FavoriteRecipe: Identifiable, Codable {
    @Attribute(.unique) var idMeal: String
    var strMeal: String
    var strInstructions: String
    var strMealThumb: String
    var strArea: String
    var ingredients: [String]
    
    init(from recipe: RecipeModel) {
        self.idMeal = recipe.idMeal
        self.strMeal = recipe.strMeal
        self.strInstructions = recipe.strInstructions
        self.strMealThumb = recipe.strMealThumb
        self.strArea = recipe.strArea
        self.ingredients = recipe.getIngredients()
    }
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb, strArea, ingredients
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strArea = try container.decode(String.self, forKey: .strArea)
        ingredients = try container.decode([String].self, forKey: .ingredients)
    }
    
    func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(idMeal, forKey: .idMeal)
           try container.encode(strMeal, forKey: .strMeal)
           try container.encode(strInstructions, forKey: .strInstructions)
           try container.encode(strMealThumb, forKey: .strMealThumb)
           try container.encode(strArea, forKey: .strArea)
           try container.encode(ingredients, forKey: .ingredients)
       }
   }
