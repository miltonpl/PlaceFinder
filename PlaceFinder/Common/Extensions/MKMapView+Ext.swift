//
//  MKMapView+Ext.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/5/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import MapKit
extension MKMapView {
    func centerToLocation(_ coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        
    }
}
