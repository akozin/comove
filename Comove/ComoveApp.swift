//
//  ComoveApp.swift
//  Comove
//
//  Created by akozin on 20.08.2022.
//

import SwiftUI

@main
struct ComoveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
