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
        
        NavigationStack{
            
            ZStack{
                
                VStack(alignment: .center, spacing: 25){
                    
                    Spacer()
                    
                    //title of the app
                    theTitle(title: "Random Foods", imageName: "tray 2" )
                    
                    //typing bar for add a new food
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
                    
                    //to go to view all added foods
                    NavigationLink(destination: FoodViews()) {
                        Text("View All Foods")                    }
                    
                    Spacer()

                    Image("food stock")
                        .resizable()
                        .frame(width: 250, height: 250)
                    
                    //the food name showing
                    Text("\(selected)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    //the random suggestion button
                    Button {
                        showRandomFood()
                    } label: {
                        //add a button image if wanted
                        Text("Random Suggestion")
                            .font(.headline)
                        .frame(width: 200, height: 35)
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                }
                .onAppear() {
                        defaultFoods()
                }
                .alert("Food already added", isPresented: $showDuplicateAlert) {
                    Button("OK", role: .cancel) {}
                }
                
            }
            
        }
    }
    // logic for initial foods
    func defaultFoods() {
        if foods.isEmpty {
            let defaults = ["Biryani", "Chicken Karahi", "Haleem"]
            
            for item in defaults {
                let food = Foods(name: item)
                context.insert(food)
            }

            try? context.save()
        }
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

//the extract views for reuseability

struct theTitle: View {
    
    var title: String = ""
    var imageName: String = ""
    
    var body: some View {
        HStack(spacing: 20){
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}
