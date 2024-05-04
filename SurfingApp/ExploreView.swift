//
//  ExploreView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("Explore the world of surfing spots!")
                    .padding()
                
                // Add more content or a list here as needed
            }
            .navigationBarTitle("Explore Surf Spots", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView().environment(\.managedObjectContext, DataController().container.viewContext)
    }
}

