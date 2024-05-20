//
//  DetailView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 05/05/2024.
//

import SwiftUI
import CoreData
import MapKit

struct DetailView: View {
    @EnvironmentObject var spot: SurfSpot
    @State private var cameraPosition: MapCameraPosition = .automatic
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            
            ZStack {
                Map(position: $cameraPosition) {
                    Marker(
                        spot.name ?? "Unknown Surf Spot",
                        systemImage: "figure.surfing",
                        coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude))
                }
                .mapStyle(.hybrid)
                .mapControls {
                    MapUserLocationButton()
                }
                .cornerRadius(21)
                .shadow(radius: 5)
                .padding()
                .frame(height: 400)
                .onAppear {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
            

            VStack(alignment: .leading, spacing: 20) {
                Text("Description: \(spot.spotDescription ?? "No Description")")
                Text("Country: \(spot.country ?? "Unknown Country")")
                Text("Continent: \(spot.continent ?? "Unknown Continent")")
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
            .frame(height: 300)

        }.navigationBarTitle(spot.name ?? "Spot Details", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
    }


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = DataController().container.viewContext

        // Utwórz przykładowy spot
        let fetchRequest: NSFetchRequest<SurfSpot> = SurfSpot.fetchRequest()
        fetchRequest.fetchLimit = 1
        let result = try! context.fetch(fetchRequest)
        let sampleSpot = result.first!

        return DetailView()
            .environmentObject(sampleSpot)
            .environment(\.managedObjectContext, context)
    }
}



