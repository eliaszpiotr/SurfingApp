//
//  SurfingAppApp.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import SwiftUI

@main
struct SurfingAppApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
