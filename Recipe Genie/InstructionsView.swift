import SwiftUI

struct InstructionsView: View {
    let instructions: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(instructions)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

