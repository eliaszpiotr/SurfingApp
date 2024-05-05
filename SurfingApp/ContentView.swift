//
//  ContentView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showAddSurfSpotForm = false
    @State private var showExploreView = false
    @State private var surfSpots: [SurfSpot] = []
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("SurfApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            .background(.thinMaterial)
            
            ZStack {
                Map(position: $cameraPosition) {
                    ForEach(surfSpots, id: \.self) { spot in
                        Marker(spot.name ?? "Unknown Surf Spot",
                               systemImage: "figure.surfing",
                               coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)).tint(.red)
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                }
            }
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
            .frame(height: 600)
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            BottomNavigationBar(showExploreView: $showExploreView, showAddSurfSpotForm: $showAddSurfSpotForm)
        }
        .fullScreenCover(isPresented: $showExploreView) {
            ExploreView()
        }
        .fullScreenCover(isPresented: $showAddSurfSpotForm, onDismiss: loadSurfSpots) {
            AddView()
        }
        .onDisappear {
            loadSurfSpots()
        }
        .onAppear {
            loadSurfSpots()
        }
    }
    
    private func loadSurfSpots() {
        let fetchRequest: NSFetchRequest<SurfSpot> = SurfSpot.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \SurfSpot.name, ascending: true)]
        do {
            surfSpots = try viewContext.fetch(fetchRequest)
            print("Surf spots loaded.")
        } catch {
            print("Failed to fetch surf spots: \(error)")
        }
    }
}

struct BottomNavigationBar: View {
    @Binding var showExploreView: Bool
    @Binding var showAddSurfSpotForm: Bool

    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                showExploreView = true
            }) {
                VStack(spacing: 3) {
                    Image(systemName: "location.circle")
                        .foregroundColor(.black)
                        .font(.title2)
                    Text("Explore")
                        .font(.caption)
                        .foregroundStyle(.black)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                VStack(spacing: 3) {
                    Image(systemName: "house.circle")
                        .foregroundColor(.black)
                        .font(.title2)
                    Text("Home")
                        .font(.caption)
                        .foregroundStyle(.black)
                }
            }
            
            Spacer()
            
            Button(action: {
                showAddSurfSpotForm = true
            }) {
                VStack(spacing: 3) {
                    Image(systemName: "pin.circle")
                        .foregroundColor(.black)
                        .font(.title2)
                    Text("Add")
                        .font(.caption)
                        .foregroundStyle(.black)
                }
            }
            
            Spacer()
        }
        .padding(.top)
        .background(.thinMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
