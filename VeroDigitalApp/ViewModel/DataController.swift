//
//  Persistence.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import CoreData

class DataController : ObservableObject {

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "VeroDigitalApp")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
