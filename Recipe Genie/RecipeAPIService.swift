import SwiftUI

class RecipeAPIService {
    
    static func fetchRecipes(query: String, completion: @escaping ([RecipeModel]) -> Void) {
        
        guard !query.isEmpty else { return }
         
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.meals ?? [])
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

