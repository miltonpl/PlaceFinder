//
//  iOSPlaceViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit

class IOSMapViewController: UIViewController {
    // MARK: - Outlet Store Properties
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search Place"
            self.searchBar.showsCancelButton = true
        }
    }
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            self.mapView.showsUserLocation = true
            self.mapView.showsCompass = true
            self.mapView.delegate = self
        }
    }
    // MARK: - Store Properties
    private var placeAnnotations: [MKAnnotation] = [] {
        willSet {
            if !placeAnnotations.isEmpty {
                self.mapView.removeAnnotations(placeAnnotations)
            }
        }
    }
    private lazy var locationHandler = LocationHandler(delegate: self)
    private var searchCompletion: SearchCompletion?
    private lazy var annotationHandler: AnnotationHandler = {
        return AnnotationHandler()
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "iOS Maps"
        self.searchCompletion = SearchCompletion(tableView: self.tableView)
        self.searchCompletion?.delegate = self
        self.locationHandler.getUserLocation()
        self.searchView.isHidden = true
        self.setupBarButtonItem()
        self.registerAnnotationViews()
    }
    
     // MARK: - Register Annotations
    private func registerAnnotationViews() {
        self.mapView.register(GasStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "GasStationAnnotationView")
        self.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        self.mapView.register(ATMAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ATMAnnotationView")
        self.mapView.register(AquariumAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AquariumAnnotationView")
        self.mapView.register(PizzaAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PizzaAnnotationView")
    }
    
    // MARK: - Camera Boundry to MapView
    func setCamera() {
        guard let coordinate = self.placeAnnotations.first?.coordinate else { return }
        let radius = 600.0
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        if #available(iOS 13.0, *) {
            let camareBoundry = MKMapView.CameraBoundary(coordinateRegion: region)
            self.mapView.setCameraBoundary(camareBoundry, animated: true)
        }
        if #available(iOS 13.0, *) {
            let cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0, maxCenterCoordinateDistance: 2000.0)
            self.mapView.setCameraZoomRange(cameraZoomRange, animated: true)
        }
    }
    
    // MARK: - Set Visible Area
    func setVisibleArea() {
        guard let coordinate = self.placeAnnotations.first?.coordinate else { return }
        let region = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.setCenter(region, animated: true)
        self.setCamera()
    }
    
    func setupBarButtonItem () {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "Local Search Off"
    }
    
    // MARK: - Override Set Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.searchBar.placeholder = "Search Place"
        if editing {
            self.editButtonItem.title = "Local Search On"
            self.searchCompletion?.localSearchState = true
        } else {
            self.editButtonItem.title = "Local Search Off"
            self.searchCompletion?.localSearchState = true
        }
    }
    
    func removeAnnotations() {
        self.placeAnnotations = []
        searchBar.text = nil
    }
}

// MARK: - Search Completion Delegate
extension IOSMapViewController: SearchCompletionDelegate {
    
    func addAnnotation() {
        if let annotations = searchCompletion?.annotations {
            self.placeAnnotations = annotations
            self.mapView.addAnnotations(annotations)
            
            if let region = searchCompletion?.boundingRegion, region.center.latitude != 0.0 && region.center.longitude != 0.0 {
                self.mapView.region = region
                
            } else {
                self.setVisibleArea()
            }
        }
    }
    
    func setSearchText(text: String) {
        self.searchBar.text = nil
        self.searchBar.placeholder = text
    }
    
    func showSearchView() {
        self.searchView.isHidden = false
    }
    
    func hideSearchView() {
        self.view.endEditing(true)
        self.searchView.isHidden = true
        self.searchCompletion?.autocompleteResult = []
    }
}

// MARK: - MapView Delegate
extension IOSMapViewController: MKMapViewDelegate {
    
    // MARK: - Add Annotation to MapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { print("not MKUersLocation"); return nil }
        return annotationHandler.getAnnotation(mapView: mapView, annotation: annotation)
    }
}

// MARK: - Search Bar Delegate
extension IOSMapViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.removeAnnotations()
        self.hideSearchView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { removeAnnotations(); return }
        self.searchCompletion?.localSearchCompletionHandler(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.removeAnnotations()
        self.searchBar.placeholder = "Search Place"
    }
}

// MARK: - User Current Location
extension IOSMapViewController: LocationHandlerProtocol {
    func received(location: CLLocation) {
        self.mapView.centerToLocation(location.coordinate, regionRadius: 4000)
    }
    
    func locationDidFail(withError error: Error) {
        print("In Main View controller ", error)
    }
}
