//
//  DataController.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SurfingApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                // Logowanie szczegółów błędu do konsoli
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                // W przypadku, gdy załaduje się poprawnie, konfigurujemy kontekst
                self.container.viewContext.automaticallyMergesChangesFromParent = true
                // Ustawiamy tryb polityki scalania zmian na wartości przekazane z kontekstu nadrzędnego
                self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            }
        }
    }
}


