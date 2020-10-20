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
        
        let flagAnnltationView = mapView.dequeueReusableAnnotationView(withIdentifier: "GasStationAnnotationView", for: annotation)
        flagAnnltationView.canShowCallout = true
        let image = UIImage(named: "gas_station")!
        let image2 = UIImage(named: "carpool")!
        
        flagAnnltationView.image = image
        flagAnnltationView.leftCalloutAccessoryView = UIImageView(image: image2)
        let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
        flagAnnltationView.centerOffset = offset
        return flagAnnltationView
    }
    
    func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView? {

        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotationView", for: annotation)
        
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
}
