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
    @Query private var foods: [FoodsModel]
    
    @State private var foodToEdit: FoodsModel?
    @State private var editedFoodName = ""
    @State private var showEditSheet = false
    
    var body: some View {
        List{
            ForEach(foods){ food in
                Text(food.name)
                    .onTapGesture {
                        foodToEdit = food
                        editedFoodName = food.name
                        showEditSheet.toggle()
                    }
            }
            .onDelete(perform: deleteFood)
        }
        .navigationTitle("All Foods")
        .sheet(isPresented: $showEditSheet){
            VStack(spacing: 50) {
                
                HStack {
                    Button("Cancel", role: .cancel) {
                        showEditSheet = false
                    }
                    
                    Spacer()
                    
                    Text("Edit food name")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    Button("Save") {
                        if let food = foodToEdit {
                            food.name = editedFoodName
                            try? context.save()
                            showEditSheet = false
                        }
                        
                    }
                }
                .padding()
                
                TextSearchBar(saveIn: $editedFoodName, barTitle: "Type new name"){
                    
                }
                
                Spacer()
            }
        }
    }
    
    func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let food = foods[index]
            context.delete(food)
        }

        try? context.save()
    }

}
//
//struct FoodViews_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodViews()
//    }
//}

#Preview {
    ContentView()
        .modelContainer(for: FoodsModel.self, inMemory: true)
}



