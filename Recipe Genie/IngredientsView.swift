import SwiftUI

struct IngredientsView: View {
    let ingredients: [String]
    @State private var checkedIngredients: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        Button(action: {
                            if checkedIngredients.contains(ingredient) {
                                checkedIngredients.remove(ingredient)
                            } else {
                                checkedIngredients.insert(ingredient)
                            }
                        }) {
                            Image(systemName: checkedIngredients.contains(ingredient) ? "checkmark.square.fill" : "square")
                                .foregroundColor(Color(red: 0.094, green: 0.239, blue: 0.518))
                        }
                        
                        Text(ingredient)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

