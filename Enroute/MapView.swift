//
//  MapView.swift
//  Enroute
//
//  Created by Bogdan Orzea on 12/5/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation]
    @Binding var selection: MKAnnotation?

    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(self.annotations)

        return mkMapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection: MKAnnotation?

        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MapViewAnnotation"

            let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true

            return view
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                self.selection = annotation
            }
        }
    }
}
