//
//  RandomFoodApp.swift
//  RandomFood
//
//  Created by Haroon Waqar on 03/07/2025.
//

import SwiftUI
import SwiftData

@main
struct RandomFoodApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Foods.self)
        }
    }
}
