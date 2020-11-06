//
//  GoopleMapViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import GoogleMaps
//import MapKit

import UIKit
class GoogleMapViewController: UIViewController {
    
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
            self.tableView.register(CompletionTableViewCell.nib(), forCellReuseIdentifier: CompletionTableViewCell.identifier)
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search Place"
            self.searchBar.showsCancelButton = true
            self.searchBar.sizeToFit()
        }
    }
    
    private lazy var locationHandler = LocationHandler(delegate: self)
    private var viewModel: GoogleViewControllerProtocol = ViewModel()
    private var placeIdDict: [String: PlaceResult] = [:]
    private var placeDetailsList = [PlaceDetails]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var markerView: MarkerView?
    // MARK: - Life Cyle View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goople Maps"
        self.locationHandler.getUserLocation()
        self.viewModel.delegate = self
        self.searchView.isHidden = true
    }
    
    func hideSearchView() {
        self.mapView.isHidden = false
        self.searchView.isHidden = true
    }
    
    func showSearchView() {
        self.mapView.isHidden = true
        self.searchView.isHidden = false
    }
    
    func resetDataSource() {
        self.placeDetailsList = []
        self.mapView.clear()
        self.markerView?.removeFromSuperview()
    }
    
    func setCameraToMapView(coordinate: Coordinates, placeId: String?) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.lat, longitude: coordinate.lng, zoom: 6.0)
        self.mapView.camera = camera
        self.hideSearchView()
        if let placeId =  placeId {
            self.viewModel.fetchPlaceInfoDetails(placeId: placeId)
        }
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    // MARK: - Add Custom MarkerView as subview when Tap
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let marker = marker as? GMSPlaceMark  else { return false }
        self.markerView?.removeFromSuperview()
        let markerView = MarkerView()
        markerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width * 0.75, height: self.view.frame.height/2)
        markerView.center = mapView.projection.point(for: marker.position)
        markerView.confiure(marker: marker)
        self.markerView = markerView
        self.view.addSubview(markerView)
        //so that marker vent is handled by delegate
        return false
    }
    
    // MARK: - Remove MarkerView when Tap away from GMSMarker
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.markerView?.removeFromSuperview()
    }
}

// MARK: - Search Bar Delegate
extension GoogleMapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.isHidden = false
        self.resetDataSource()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.resetDataSource()
        self.hideSearchView()
        self.view.endEditing(true)
        self.searchBar.placeholder = "Search Place"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    // MARK: - Search Text Input if greater then 3 characters
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { resetDataSource(); return }
        if searchText.count > 3 {
            self.viewModel.handlePlaceSearch(text: searchText)
        }
    }
}

extension GoogleMapViewController: LocationHandlerProtocol {
    // MARK: - User Location
    func received(location: CLLocation) {
        setCameraToMapView(coordinate: Coordinates(lat: location.coordinate.latitude, lng: location.coordinate.longitude), placeId: nil)
    }
    
    func locationDidFail(withError error: Error) {
        print("Error: ", error)
    }
}

extension GoogleMapViewController: ViewModelProtocol {
    
   // MARK: - Result about A Spesific Place From Google Place API
    func placeDetailResult(place: ResultDetails, placeId: String) {
        if let currentPlace = placeIdDict[placeId], let coordinate = currentPlace.geometry?.location, let name = currentPlace.name {
            let marker = GMSPlaceMark(name: name, placeDetails: place, coordinate: coordinate)
            marker.map = mapView
        }
    }
    
    // MARK: - Result From Google Place API
  func dataResult(places: [PlaceResult]) {
        for place in places {
            if let placeId = place.placeId {
                placeIdDict[placeId] = place
            }
            if let coordinate = place.geometry?.location {
                placeDetailsList.append( PlaceDetails(title: place.name, subtitle: place.address, coordinates: coordinate, placeId: place.placeId))
            }
        }
        self.showSearchView()
    }
}

// MARK: - Table View Delegate and Table View DataSource
extension GoogleMapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coordinate = self.placeDetailsList[indexPath.row].coordinates {
            setCameraToMapView(coordinate: coordinate, placeId: self.placeDetailsList[indexPath.row].placeId)
            searchBar.text = nil
            self.searchBar.placeholder = placeDetailsList[indexPath.row].title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.placeDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompletionTableViewCell", for: indexPath) as?
            CompletionTableViewCell else { fatalError("Unable to dequeueReusableCell: SearchTableViewCell ")}
              
        cell.configure(place: placeDetailsList[indexPath.row])
        return cell
    }
}
