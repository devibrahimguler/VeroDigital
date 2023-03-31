//
//  VeroDigitalAppApp.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

@main
struct VeroDigitalAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
