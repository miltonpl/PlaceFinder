//
//  SearchDataSource.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/20/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit

protocol TableViewDataSourceDelegate: AnyObject {
    func addAnnotation()
    func hideResult()
}

class TableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TableViewDataSourceDelegate?
    public var autocompleteResult = [MKLocalSearchCompletion]()
    public var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    private var placeSearchType: String?
    private let tableView: UITableView
    private var places: [MKMapItem]?
    public var annotations: [MKAnnotation]?
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.setUp()
    }
    
    private func setUp() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SearchTableViewCell.nib(), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    private func setPlacesNearBy() {
        guard let places = self.places else { return }
        var annotations: [MKAnnotation] = []
        for mapItem in places {
            switch placeSearchType {
            case "Pizza":
                guard let name = mapItem.name, let phone = mapItem.phoneNumber else { continue }
                annotations.append(PizzaAnnotation(coordinate: mapItem.placemark.coordinate, title: name, subtitle: phone, isOpen: "yes"))
            case "Gas Stations":
                guard let name = mapItem.name, let phone = mapItem.phoneNumber else { continue }
                annotations.append(GasStationAnnotation(coordinate: mapItem.placemark.coordinate, title: name, subtitle: phone, rating: 4.0))
                
            default:
                guard let name = mapItem.name, let phone = mapItem.phoneNumber else { continue }
                annotations.append(CustomAnnotation(coordinate: mapItem.placemark.coordinate, title: name, subtitle: phone ))
            }
        }
        
        self.annotations = annotations
    }
    
    private func geocodingResult(localSearch: MKLocalSearchCompletion) {
        let placeName = localSearch.title
        let plceAddress = localSearch.subtitle
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(plceAddress) { placeMark, error in
            guard error == nil else { return }
            if let coordinates = placeMark?.first?.location?.coordinate {
                DispatchQueue.main.async {
                    let annotation = CustomAnnotation(coordinate: coordinates, title: placeName, subtitle: plceAddress)
                    print(annotation)
                    self.delegate?.addAnnotation()
                }
            }
        }
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        self.placeSearchType = searchRequest.naturalLanguageQuery
        search(using: searchRequest)
    }
    
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        if #available(iOS 13.0, *) {
            searchRequest.resultTypes = .pointOfInterest
        } else {
            // Fallback on earlier versions
        }
        
        localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                print("localSearch:", error ?? "Not ERROR")
                return
            }
            self.places = response?.mapItems
            
            if let boundingRegion = response?.boundingRegion {
                self.boundingRegion = boundingRegion
                self.setPlacesNearBy()
                self.delegate?.addAnnotation()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(for: autocompleteResult[indexPath.row])
        delegate?.hideResult()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as?
            SearchTableViewCell else { fatalError("Unable to dequeueReusableCell: SearchTableViewCell ")}
        let place = PlaceDetails(title: self.autocompleteResult[indexPath.row].title, subtitle: self.autocompleteResult[indexPath.row].subtitle)
        cell.configure(place: place)
        return cell
    }
}
