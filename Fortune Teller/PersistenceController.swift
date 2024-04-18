//
//  PersistenceController.swift
//  Fortune Teller
//
//  Created by E Martin on 4/18/24.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "UserSettings") // Replace with your data model name
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
