//
//  Geocoder.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import MapKit
import UIKit

class Geocoder {
    private var geocoder: CLGeocoder? {
        willSet {
            self.geocoder?.cancelGeocode()
        }
    }
    
    static let shared = Geocoder()
    private init() {}
   
    public func geocodeAddressStringResult(for queryString: String, completion: @escaping([MKMapItem]?) -> Void) {
        var places = [MKMapItem]()
        self.geocoder = CLGeocoder()
        self.geocoder?.geocodeAddressString(queryString) { clPlaceMarks, error in
            guard error == nil, let clPlaceMarks = clPlaceMarks else {
                completion(nil)
                return }
            
            clPlaceMarks.forEach { clPlaceMark in
                let placeMark = MKPlacemark(placemark: clPlaceMark)
                places.append(MKMapItem(placemark: placeMark))
            }
            completion(places)
        }
    }
    
    public func reverseGeocodeLocationResult(location: CLLocation, completion: @escaping([MKMapItem]?) -> Void) {
        var places = [MKMapItem]()
        self.geocoder = CLGeocoder()
        self.geocoder?.reverseGeocodeLocation(location) { clPlacemarks, error in
            guard error == nil, let clPlacemarks = clPlacemarks  else {
                completion(nil)
                return }
            
            clPlacemarks.forEach { clPlacemark in
                let placeMark = MKPlacemark(placemark: clPlacemark)
                places.append(MKMapItem(placemark: placeMark))
            }
        }
        completion(places)
    }
}
