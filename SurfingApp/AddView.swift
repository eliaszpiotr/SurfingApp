//
//  AddView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 21/04/2024.
//

import SwiftUI
import MapKit


struct AddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var spotDescription: String = ""
    @State private var country: String = ""
    @State private var continent: String = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20.0, longitude: -158.0), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    @State private var selectedLocation: CLLocationCoordinate2D?
    
    let continents = ["", "North America", "South America", "Europe", "Africa", "Asia", "Oceania"]
    
    let countries = [
        "", "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua & Deps", "Argentina",
        "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
        "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia Herzegovina", "Botswana",
        "Brazil", "Brunei", "Bulgaria", "Burkina", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde",
        "Central African Rep", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Congo {Democratic Rep}",
        "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica",
        "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea",
        "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana",
        "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary",
        "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland {Republic}", "Israel", "Italy", "Ivory Coast",
        "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea North", "Korea South", "Kosovo",
        "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein",
        "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta",
        "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia",
        "Montenegro", "Morocco", "Mozambique", "Myanmar, {Burma}", "Namibia", "Nauru", "Nepal", "Netherlands",
        "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Panama",
        "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania",
        "Russian Federation", "Rwanda", "St Kitts & Nevis", "St Lucia", "Saint Vincent & the Grenadines",
        "Samoa", "San Marino", "Sao Tome & Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles",
        "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa",
        "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria",
        "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad & Tobago", "Tunisia",
        "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
        "USA", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen",
        "Zambia", "Zimbabwe"
    ]



    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tap on the map to select location")) {
                    InteractiveMapView(region: $region, selectedLocation: $selectedLocation)
                        .frame(height: 350)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Section(header: Text("Surf Spot Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $spotDescription)
                    
                    Picker("Country", selection: $country) {
                                           ForEach(countries, id: \.self) {
                                               Text($0).tag($0 as String?)
                                           }
                                       }
                    Picker("Continent",
                           selection: $continent) {
                            ForEach(continents, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Button("Save Surf Spot") {
                    addSurfSpot()
                }
                .disabled(selectedLocation == nil || name.isEmpty || country.isEmpty || continent.isEmpty) // Disable the save button if no location is selected
            }
            .navigationBarTitle("Add New Surf Spot", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
    }

    private func addSurfSpot() {
            let newSurfSpot = SurfSpot(context: viewContext)
            newSurfSpot.id = UUID()
            newSurfSpot.name = name
            newSurfSpot.spotDescription = spotDescription
            newSurfSpot.country = country
            newSurfSpot.continent = continent
            if let location = selectedLocation {
                newSurfSpot.latitude = location.latitude
                newSurfSpot.longitude = location.longitude
            }
            do {
                try viewContext.save()
                print("Surf spot saved successfully! \(String(describing: newSurfSpot.name)) \(newSurfSpot.latitude) \(newSurfSpot.longitude)")
                presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    struct AddView_Previews: PreviewProvider {
        static var previews: some View {
            AddView().environment(\.managedObjectContext, DataController().container.viewContext)
        }
    }
