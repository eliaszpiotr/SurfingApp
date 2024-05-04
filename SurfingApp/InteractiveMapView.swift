//
//  InteractiveMapView.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 22/04/2024.
//

import SwiftUI
import MapKit

struct InteractiveMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapRecognizer)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        if let location = selectedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: InteractiveMapView

        init(_ parent: InteractiveMapView) {
            self.parent = parent
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let location = sender.location(in: sender.view)
            let coordinate = (sender.view as! MKMapView).convert(location, toCoordinateFrom: sender.view)
            parent.selectedLocation = coordinate

            // Usuwamy wszystkie poprzednie znaczniki, ponieważ chcemy tylko jeden
            (sender.view as! MKMapView).removeAnnotations((sender.view as! MKMapView).annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            (sender.view as! MKMapView).addAnnotation(annotation)
        }
    }
}

