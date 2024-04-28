//
//  CoreDataStack.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserSettings")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()
}
