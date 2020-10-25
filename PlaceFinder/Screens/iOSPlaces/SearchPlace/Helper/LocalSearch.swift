//
//  LocalSearch.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import Foundation

class LocalSearch {
    
    public var placeSearchType: String?
    public var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    public var places: [MKMapItem]? {
        didSet {
            print("local search places: ", places?.count ?? "something went wrong")
        }
    }
    private var localSearch: MKLocalSearch? {
        willSet {
            self.places = nil
            self.localSearch?.cancel()
        }
    }
//    public var manager = LocalSearch()
//    private init() {}
    public func search(using searchRequest: MKLocalSearch.Request, complition: @escaping([MKMapItem]?) -> Void ) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        if #available(iOS 13.0, *) {
            searchRequest.resultTypes = .pointOfInterest
        }
        
        self.localSearch = MKLocalSearch(request: searchRequest)
        self.localSearch?.start { response, error in
            guard error == nil else {
                print("localSearch:", error ?? "Not ERROR")
                complition(nil)
                return
            }
            if let boundingRegion = response?.boundingRegion {
                self.boundingRegion = boundingRegion
            }
            complition(response?.mapItems)
        }
    }
}
