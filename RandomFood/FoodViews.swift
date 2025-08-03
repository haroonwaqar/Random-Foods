//
//  FoodViews.swift
//  RandomFood
//
//  Created by Haroon Waqar on 02/08/2025.
//

import SwiftUI
import SwiftData

struct FoodViews: View {
    @Environment(\.modelContext) private var context
    @Query var foods: [Foods]
    
    var body: some View {
        List{
            ForEach(foods){ food in
                Text(food.name)
            }
            .onDelete(perform: deleteFood)
        }
        .navigationTitle("All Foods")
    }
    
    func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let food = foods[index]
            context.delete(food)
        }

        try? context.save()
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Foods.self, inMemory: true)
}



