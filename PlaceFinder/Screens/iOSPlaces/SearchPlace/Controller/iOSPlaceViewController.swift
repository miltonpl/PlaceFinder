//
//  iOSPlaceViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit

class IOSPlaceViewController: UIViewController, SearchComplitionResultDelegate {
    
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchC = MKLocalSearchCompleter()
        searchC.delegate = self
        return searchC
    }()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search Place"
            self.searchBar.showsCancelButton = true
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.showsUserLocation = true
            self.mapView.showsCompass = true
            self.mapView.delegate = self
        }
    }
    
    var placeAnnotations: [MKAnnotation] = [] {
        didSet {
//                setVisibleArea()
        }
        willSet {
            if !placeAnnotations.isEmpty {
                self.mapView.removeAnnotations(placeAnnotations)
            }
        }
    }
    lazy var locationHandler = LocationHandler(delegate: self)
    var searchComplitionResult: SearchComplitionResult?
    lazy var annotationHandler: AnnotationHandler = {
        return AnnotationHandler()
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "iOS Maps"
        self.searchComplitionResult = SearchComplitionResult(tableView: self.tableView)
        self.searchComplitionResult?.delegate = self
        self.locationHandler.getUserLocation()
        self.searchView.isHidden = true
        self.setupSettingAction()
        self.registerMapAnnotationViews()
    }
    
    private func registerMapAnnotationViews() {
        self.mapView.register(GasStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "GasStationAnnotationView")
        self.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        self.mapView.register(ATMAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ATMAnnotationView")
        self.mapView.register(AquariumAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AquariumAnnotationView")
        self.mapView.register(PizzaAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PizzaAnnotationView")
    }
    func setCamara() {
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
    
    func setVisibleArea() {
        guard let coordinate = self.placeAnnotations.first?.coordinate else { return }
        let region = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.setCenter(region, animated: true)
        self.setCamara()
    }
    
    func setupSettingAction () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: #selector(categoriesAction(_:)))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "Local Search Off"
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.searchBar.placeholder = "Search Place"
        if editing {
            self.editButtonItem.title = "Local Search On"
            self.searchComplitionResult?.localSearchState = true
        } else {
            self.editButtonItem.title = "Local Search Off"
            self.searchComplitionResult?.localSearchState = true

        }
    }
    
    @objc func categoriesAction(_ sender: UIBarButtonItem ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let categoriesViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else {
            fatalError("Unagle to instantiateViewController") }
        
        let navController = UINavigationController(rootViewController: categoriesViewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func showResult(results: [MKLocalSearchCompletion]) {
        self.searchView.isHidden = false
        searchComplitionResult?.autocompleteResult = results
    }
    
    func removeAnnotations() {
        self.placeAnnotations = []
    }
    
    func hideSearchComplitionResult() {
        self.view.endEditing(true)
        self.searchView.isHidden = true
        self.searchComplitionResult?.autocompleteResult = []
        //        self.setVisibleArea()
    }
    
    func addAnnotation() {
        if let annotations = searchComplitionResult?.annotations {
            self.placeAnnotations = annotations
            self.mapView.addAnnotations(annotations)
        }
        
        if let region =  searchComplitionResult?.boundingRegion {
            self.mapView.region = region
        }
    }
    
    func setSearchTest(text: String) {
        self.searchBar.text = nil
        self.searchBar.placeholder = text
    }
}
extension IOSPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { print("not MKUersLocation"); return nil }
        return annotationHandler.getAnnotation(mapView: mapView, annotation: annotation)
    }
}

extension IOSPlaceViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.removeAnnotations()
        self.hideSearchComplitionResult()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { removeAnnotations(); return }
        self.searchCompleter.queryFragment = searchText
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.removeAnnotations()
        self.searchBar.placeholder = "Search Place"
    }
}

extension IOSPlaceViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.showResult(results: completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension IOSPlaceViewController: LocationHandlerProtocol {
    func received(location: CLLocation) {
        print(location)
    }
    
    func locationDidFail(withError error: Error) {
        print("In Main View controller ", error)
    }
}
