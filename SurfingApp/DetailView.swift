//
//  DetailView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 05/05/2024.
//

import SwiftUI
import CoreData
import MapKit
import WeatherKit

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
            VStack {
                
            }
            .padding()
            .navigationBarTitle("SurfSpot Name", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView().environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
