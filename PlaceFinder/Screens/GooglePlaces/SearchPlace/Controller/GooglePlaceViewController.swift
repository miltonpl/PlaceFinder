//
//  SearchPlaceViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import GooglePlaces
import GoogleMaps
import MapKit
import UIKit

class GooglePlaceViewController: UIViewController {
    var resultViewController: GMSAutocompleteResultsViewController!
    var searchController: UISearchController!
    //    var resultTextView: UITextView!
    
    @IBOutlet weak var mapViewContainer: UIView!
    //    private var viewModel: SearchLoactionViewModelProtocol = PlaceViewModel()
    private var googleMapsView: GMSMapView!
    //    private var placesClient: GMSPlacesClient!
    private var resultArray = [String]()
    //    weak var delegate: GooglePlaceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goople Maps"
        GMSServices.provideAPIKey(GooglePlaces.googleKey)
        GMSPlacesClient.provideAPIKey(GooglePlaces.googleKey)
        
        self.resultViewController = GMSAutocompleteResultsViewController()
        self.resultViewController.delegate = self
        
        self.searchController = UISearchController(searchResultsController: resultViewController)
        self.searchController.searchResultsUpdater = resultViewController
        
        self.mapViewContainer.addSubview(searchController.searchBar)
        
        self.view.addSubview(mapViewContainer)
        
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        
        title = "Google Places"
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
    }
    func showResults(place: GMSPlace) {
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place attributions: \(String(describing: place.coordinate))")
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 6.0)
        self.googleMapsView = GMSMapView.map(withFrame: mapViewContainer.frame, camera: camera)
        self.view.addSubview(self.googleMapsView)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.map = googleMapsView
    }
    
    func hideResults() {
        
    }
}
extension GooglePlaceViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController.isActive = false
        self.showResults(place: place)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
