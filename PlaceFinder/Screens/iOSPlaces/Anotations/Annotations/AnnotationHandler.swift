//
//  SetupAnnotation.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/20/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import Foundation

struct AnnotationHandler {
    
    func getAnnotation(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? GasStationAnnotation {
            annotationView = setupGasStationAnnotationView(for: annotation, on: mapView)
        } else if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
            
        } else if let annotation = annotation as? ATMAnnotation {
            annotationView = setupATMAnnotationView(for: annotation, on: mapView)
            
        } else if let annotation = annotation as? AquariumAnnotation {
            annotationView = setupAquarimAnnotationView(for: annotation, on: mapView)
            
        } else if let annotation = annotation as? PizzaAnnotation {
            annotationView = setupPizzaAnnotationView(for: annotation, on: mapView)
            
        } else {
            let  markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "markerAnnotationView")
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.image = UIImage(named: "place_targe")!
            markerAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = markerAnnotationView
        }
        return annotationView
    }
    
    func setupGasStationAnnotationView(for annotation: GasStationAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "GasStationAnnotationView", for: annotation)
        flagAnnotationView.canShowCallout = true
        let image = UIImage(named: "marker")!
        let image2 = UIImage(named: "gas_station")!
        flagAnnotationView.image = image
        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image2)
        let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
        flagAnnotationView.centerOffset = offset
        return flagAnnotationView
    }
    
    func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotationView")
        customAnnotationView?.annotation = annotation
        customAnnotationView?.canShowCallout = false
        customAnnotationView?.image = UIImage(named: "marker")!
        return customAnnotationView
    }

    func setupAquarimAnnotationView(for annotation: AquariumAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AquariumAnnotationView", for: annotation)
        
        flagAnnotationView.canShowCallout = true
        let image = UIImage(named: "place_marker")!
        let image2 = UIImage(named: "google_maps")!
        
        flagAnnotationView.annotation = annotation
        flagAnnotationView.image = image
        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image2)
        let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
        flagAnnotationView.centerOffset = offset
        return flagAnnotationView
        
    }
    
    func setupATMAnnotationView(for annotation: ATMAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ATMAnnotationView", for: annotation)
        
        flagAnnotationView.canShowCallout = true
        let image = UIImage(named: "place_marker")!
        let image2 = UIImage(named: "google_maps")!
        
        flagAnnotationView.annotation = annotation
        flagAnnotationView.image = image
        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image2)
        let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
        flagAnnotationView.centerOffset = offset
        return flagAnnotationView
    }
    func setupPizzaAnnotationView(for annotation: PizzaAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ATMAnnotationView", for: annotation)
        
        flagAnnotationView.canShowCallout = true
        let image = UIImage(named: "pizza_marker")!
        let image2 = UIImage(named: "pizza")!
        
        flagAnnotationView.annotation = annotation
        flagAnnotationView.image = image
        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image2)
        let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
        flagAnnotationView.centerOffset = offset
        return flagAnnotationView
    }
}
