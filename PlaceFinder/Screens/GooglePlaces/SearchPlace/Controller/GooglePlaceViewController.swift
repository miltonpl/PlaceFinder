//
//  SearchPlaceViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import GooglePlaces
import GoogleMaps
//import MapKit
import UIKit
import MapKit
class GooglePlaceViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(SearchTableViewCell.nib(), forCellReuseIdentifier: SearchTableViewCell.identifier)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search Place"
            self.searchBar.showsCancelButton = true
            self.searchBar.sizeToFit()
        }
    }
    
    private var googleMapView: GMSMapView! {
        didSet {
            self.googleMapView.delegate = self
            self.googleMapView.isMyLocationEnabled = true
        }
    }
    lazy var locationHandler = LocationHandler(delegate: self)
      var viewModel: PlaceViewModelProtocol = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goople Maps"
        self.locationHandler.getUserLocation()
        self.viewModel.delegate = self
//        self.searchView.isHidden = true
//        showResults(coordinate: Coordinates(lat: 77.0, lng: 245.0))
        
    }
    
    func showResults(place: PlaceResult) {
        if let coordinate = place.geometry?.location {
            print("coordinate place: ", coordinate)
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.lat, longitude: coordinate.lng, zoom: 6.0)
            self.googleMapView = GMSMapView.map(withFrame: mapView.frame, camera: camera)
            //        self.mapView.addSubview(self.googleMapView)
            self.view.addSubview(self.googleMapView)
        }
        
        let marker = GMSPlaceMark(place: place)
        marker.map = googleMapView
    }
    
    func hideResults() {
        self.searchView.isHidden = true
        self.tableView.reloadData()
        
    }
    func resetDataSource() {
        
    }
}

extension GooglePlaceViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        print("In markerInfoWindow marker: GMSMarker")
        guard let marker = marker as? GMSPlaceMark else { return nil }
        guard  let viewMaker = UIView.viewNib("MarkerView") as? MarkerView  else {
            return nil }
        viewMaker.confiure(marker: marker)
        return viewMaker
    }
}

extension GooglePlaceViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.isHidden = false
        resetDataSource()
        print("SearchBarTextDidBeginEding")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.resetDataSource()
        self.hideResults()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { resetDataSource(); return }
        if searchText.count > 3 {
            self.viewModel.handlePlaceSearch(text: searchText)
        }
    }
}

extension GooglePlaceViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        print(location)
    }
    
    func locationDidFail(withError error: Error) {
        print("Error: ", error)
    }
}

extension GooglePlaceViewController: ViewModelProtocol {
  
    func dataResult(places: [PlaceResult]) {
        if let firstLoacation = places.first {
            showResults(place: firstLoacation)
        }
    }
   
    func didFailWithError(error: CustomError) {
        print("ViewModelProtocol: didFailWithError", error as Error)
    }
}
extension GooglePlaceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as?
            SearchTableViewCell else { fatalError("Unable to dequeueReusableCell: SearchTableViewCell ")}
        //        let place = PlaceDetails(title: self.autocompleteResult[indexPath.row].title, subtitle: self.autocompleteResult[indexPath.row].subtitle)
        //        cell.configure(place: place)
        return cell
    }
}
