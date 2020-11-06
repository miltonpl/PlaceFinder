//
//  SearchDataSource.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/20/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit

protocol SearchCompletionDelegate: AnyObject {
    func addAnnotation()
    func hideSearchView()
    func showSearchView()
    func setSearchText(text: String)
}

class SearchCompletion: NSObject {
    
    weak var delegate: SearchCompletionDelegate?
    public var autocompleteResult = [MKLocalSearchCompletion]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    public var localSearchState = false
    private var placeSearchType: String?
    private let tableView: UITableView
    private var places: [MKMapItem]?
    public var annotations: [MKAnnotation]?
    private var localSearchCompletion: LocalSearchCompletion?
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
    
    lazy var localSearchResult = LocalSearch()
    private func setUp() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CompletionTableViewCell.nib(), forCellReuseIdentifier: CompletionTableViewCell.identifier)
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
                annotations.append(CustomAnnotation(coordinate: mapItem.placemark.coordinate, mapItem: mapItem))
            }
        }
        self.annotations = annotations
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        self.placeSearchType = searchRequest.naturalLanguageQuery
        localSearchResult.boundingRegion = self.boundingRegion
        
        localSearchResult.search(using: searchRequest) { mapItem in
            self.places = mapItem
            self.boundingRegion = self.localSearchResult.boundingRegion
            self.setPlacesNearBy()
            self.delegate?.addAnnotation()
        }
    }
    
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        localSearchResult.boundingRegion = self.boundingRegion
        
        localSearchResult.search(using: searchRequest) { mapItem in
            self.places = mapItem
            self.boundingRegion = self.localSearchResult.boundingRegion
            self.setPlacesNearBy()
            self.delegate?.addAnnotation()
        }
    }
    
    private func geocoderSearch(text: String) {
        self.placeSearchType = "Unkown"
        Geocoder.shared.geocodeAddressStringResult(for: text) { mapItem in
            self.places = mapItem
            
            if let place = self.places?.first {
                self.boundingRegion = MKCoordinateRegion(center: place.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                self.setPlacesNearBy()
                self.delegate?.addAnnotation()
              
            } else {
                self.delegate?.setSearchText(text: "No Resuts, Try local search")
            }
        }
    }
    
    public func localSearchCompletionHandler(text: String) {
        self.localSearchCompletion = LocalSearchCompletion(text: text)
        self.localSearchCompletion?.delegate = self
    }
}

extension SearchCompletion: LocalSearchCompletionDelegate {
    func result(_ localSearchCompletion: [MKLocalSearchCompletion]) {
        self.autocompleteResult = localSearchCompletion
        delegate?.showSearchView()
    }
}

extension SearchCompletion: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if localSearchState {
            search(for: autocompleteResult[indexPath.row])
        } else {
            let result = autocompleteResult[indexPath.row]
            geocoderSearch(text: result.title + result.subtitle)
        }
        delegate?.setSearchText(text: autocompleteResult[indexPath.row].title)
        delegate?.hideSearchView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompletionTableViewCell", for: indexPath) as?
            CompletionTableViewCell else { fatalError("Unable to dequeueReusableCell: SearchTableViewCell ")}
        let place = PlaceDetails(title: self.autocompleteResult[indexPath.row].title, subtitle: self.autocompleteResult[indexPath.row].subtitle)
        cell.configure(place: place)
        return cell
    }
    
}
