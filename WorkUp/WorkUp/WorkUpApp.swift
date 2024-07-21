//
//  WorkUpApp.swift
//  WorkUp
//
//  Created by Damin on 7/21/24.
//

import SwiftUI
import SwiftData

@main
struct WorkUpApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([NewCard.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TestMainView()
                .modelContainer(modelContainer)
        }
    }
}

