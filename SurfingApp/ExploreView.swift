//
//  ExploreView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedContinent: String?

    // List of continents - this could also be dynamically fetched if needed
    let continents = ["Africa", "Asia", "Europe", "North America", "Oceania", "South America"]

    var body: some View {
        NavigationView {
            List {
                ForEach(continents, id: \.self) { continent in
                    NavigationLink(destination: CountryListView(continent: continent)) {
                        Text(continent)
                    }
                }
            }
            .navigationBarTitle("Explore Surf Spots", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
    }
}

// View to display countries within a selected continent
struct CountryListView: View {
    var continent: String
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest var surfSpots: FetchedResults<SurfSpot>
    private var countries: [String] {
        Set(surfSpots.map { $0.country ?? "Unknown" }).sorted()
    }

    init(continent: String) {
        self.continent = continent
        self._surfSpots = FetchRequest(
            entity: SurfSpot.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \SurfSpot.country, ascending: true)],
            predicate: NSPredicate(format: "continent == %@", continent)
        )
    }

    var body: some View {
            List(countries, id: \.self) { country in
                NavigationLink(destination: CountrySpotListView(country: country, continent: continent)) {
                    Text(country)
                }
            }
            .navigationBarTitle("\(continent)", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
    }
}

struct CountrySpotListView: View {
    var country: String
    var continent: String
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest var surfSpots: FetchedResults<SurfSpot>

    init(country: String, continent: String) {
        self.country = country
        self.continent = continent
        self._surfSpots = FetchRequest(
            entity: SurfSpot.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \SurfSpot.name, ascending: true)],
            predicate: NSPredicate(format: "continent == %@ AND country == %@", continent, country)
        )
    }

    var body: some View {
        List(surfSpots, id: \.self) { spot in
            NavigationLink(destination: DetailView().environmentObject(spot)) {
                Text(spot.name ?? "Unknown Spot")
            }
        }
        .navigationBarTitle("\(country)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Back") {
            presentationMode.wrappedValue.dismiss()
        }.foregroundColor(.red))
    }
}


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView().environment(\.managedObjectContext, DataController().container.viewContext)
    }
}

