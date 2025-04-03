import SwiftUI

struct AddAllergyView: View {
    
    // MARK: - Properties
    @Binding var selectedAllergies: [String]
    @Environment(\.dismiss) private var dismiss
    @State private var newAllergy: String = ""
    let commonAllergies = ["Peanuts", " Dairy ","Tree nuts",
                           " Gluten ", " Eggs ", "Seafood",
                           " Wheat ", "Shellfish", "Ketchup",
                           "Onions", " Garlic ", "Chocolate"]
    @AppStorage("allergySelections") private var storedAllergies: String = "{}"
    @State private var allergySelections: [String: Bool] = [:]

    // MARK: - Init
    init(selectedAllergies: Binding<[String]>) {
        self._selectedAllergies = selectedAllergies
    }
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 16) {
            Color.clear.frame(height: 7)

            Text("Common Allergies:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 7) {
                ForEach(commonAllergies, id: \.self) { allergy in
                    Text(allergy)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .onTapGesture {
                            toggleAllergySelection(allergy)
                        }
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Added Allergies:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                ForEach(Array(allergySelections.keys), id: \.self) { allergy in
                    HStack {
                        Text(allergy)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(allergySelections[allergy] == true ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                            .foregroundColor(allergySelections[allergy] == true ? .red : .black)
                            .cornerRadius(15)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { allergySelections[allergy] ?? false },
                            set: { isOn in updateSelection(allergy: allergy, isSelected: isOn) }
                        ))
                        .labelsHidden()
                        .tint(Color(red: 0.094, green: 0.239, blue: 0.518))
                        
                        Button(action: { removeAllergy(allergy) }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitle("Add Allergies", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.white)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Allergies")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color(red: 0.094, green: 0.239, blue: 0.518), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            loadStoredAllergies()
        }
    }
    
    // MARK: - Functions
    private func addNewAllergy() {
        if !newAllergy.isEmpty && allergySelections[newAllergy] == nil {
            allergySelections[newAllergy] = true
            selectedAllergies.append(newAllergy)
            saveAllergies()
            newAllergy = ""
        }
    }
    
    private func removeAllergy(_ allergy: String) {
        allergySelections.removeValue(forKey: allergy)
        selectedAllergies.removeAll { $0 == allergy }
        saveAllergies()
    }
    
    private func updateSelection(allergy: String, isSelected: Bool) {
        allergySelections[allergy] = isSelected
        if isSelected {
            if !selectedAllergies.contains(allergy) {
                selectedAllergies.append(allergy)
            }
        } else {
            selectedAllergies.removeAll { $0 == allergy }
        }
        saveAllergies()
    }

    private func toggleAllergySelection(_ allergy: String) {
        if allergySelections[allergy] == true {
            allergySelections[allergy] = false
            selectedAllergies.removeAll { $0 == allergy }
        } else {
            allergySelections[allergy] = true
            if !selectedAllergies.contains(allergy) {
                selectedAllergies.append(allergy)
            }
        }
        saveAllergies()
    }
    
    private func saveAllergies() {
        if let data = try? JSONEncoder().encode(allergySelections) {
            storedAllergies = String(data: data, encoding: .utf8) ?? "{}"
        }
    }

    private func loadStoredAllergies() {
        if let data = storedAllergies.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String: Bool].self, from: data) {
            allergySelections = decoded
            selectedAllergies = allergySelections.filter { $0.value }.map { $0.key }
        }
    }
}

#Preview {
    NavigationStack {
        AddAllergyView(selectedAllergies: .constant([]))
    }
}

