//
//  ContentView.swift
//  RandomFood
//
//  Created by Haroon Waqar on 03/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var foods: [Foods]
    
    @State var selected = "Let's start cooking!"
    @State var newFood = ""
    @State var showDuplicateAlert = false

    
    var body: some View {

        ZStack{
                                            
            VStack(alignment: .center, spacing: 25){
                
                Spacer()
                                
                HStack(spacing: 20){
                    Text("Random Foods")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image("tray 2")
                        .resizable().frame(width: 50, height: 50)
                }
                
                TextField("Add a new food", text: $newFood)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .foregroundColor(.primary)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        addNewFood()
                    }
                    .padding(.horizontal)
                
                Spacer()
                
                Image("food stock").resizable().frame(width: 250, height: 250)
                    
                
                Text("\(selected)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Button {
                    showRandomFood()
                } label: {
                    //add a button image if wanted
                    Text("Random Suggestion")
                        .font(.headline)
                }.buttonStyle(.bordered)
                
                Spacer()
                                
            }
            .onAppear(){
                defaultFoods()
            }
            .alert("Food already exists", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) {}
            }
            
        }
        
    }
    // logic for initial foods
    func defaultFoods() {
        
        let defaults = ["Biryani", "Chicken Karahi", "Haleem", "Dal chawal"]

        for item in defaults {
            let food = Foods(name: item)
            context.insert(food)
        }
        try? context.save()
        
//        selected = defaults.randomElement() ?? "No foods available"
    }
    
    // logic for showing random food
    func showRandomFood() {
        if let random = foods.randomElement() {
            selected = random.name
        } else {
            selected = "No foods available!"
        }
    }
    
    // logic for getting user new foods
    func addNewFood() {
        let trimmed = newFood.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Skip if empty after trimming
        guard !trimmed.isEmpty else { return }
        
        // Check for duplicates (case-insensitive)
        let exists = foods.contains { $0.name.lowercased() == trimmed.lowercased() }
        guard !exists else {
            showDuplicateAlert = true
            newFood = "" // Clear the text field
            return
        }
        
        // Add the new food
        context.insert(Foods(name: trimmed))
        newFood = "" // Clear the text field
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Foods.self, inMemory: true)
}
