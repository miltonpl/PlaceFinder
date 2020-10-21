//
//  iOSPlaceViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
//import CoreLocation
import MapKit
class IOSPlaceViewController: UIViewController, TableViewDataSourceDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //create a completer
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
    var dataSource: [MKAnnotation] = [] {
        didSet {
            setVisibleArea()
        }
    }
    
    lazy var locationHandler = LocationHandler(delegate: self)
    var viewModel: PlaceViewModelProtocol = ViewModel()
    var tableViewDataSource: TableViewDataSource?
    lazy var annotationHandler: AnnotationHandler = {
        return AnnotationHandler()
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "iOS Maps"
        self.tableViewDataSource = TableViewDataSource(tableView: self.tableView)
        self.tableViewDataSource?.delegate = self
        self.viewModel.delegate = self
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
        guard let coordinate = self.dataSource.first?.coordinate else { return }
        let radius = 1000.0
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        let camareBoundry = MKMapView.CameraBoundary(coordinateRegion: region)
        self.mapView.setCameraBoundary(camareBoundry, animated: true)
    }
   
    func addAnnotation() {
        if let region =  tableViewDataSource?.boundingRegion {
            print("stting region")
            self.mapView.region = region
        }
        if let annotations = tableViewDataSource?.annotations {
            self.dataSource = annotations
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func setVisibleArea() {
        guard let coordinate = self.dataSource.first?.coordinate else { return }
        let region = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.setCenter(region, animated: true)
//        self.setCamara()
    }
    
    func setupSettingAction () {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: #selector(categoriesAction(_:)))
    }
    
    // MARK: - Instantiate My CollectionView Controller
    @objc func categoriesAction(_ sender: UIBarButtonItem ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let categoriesViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else {
            fatalError("Unagle to instantiateViewController") }
        
        let navController = UINavigationController(rootViewController: categoriesViewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func hideResult() {
        self.searchView.isHidden = true
        self.tableViewDataSource?.autocompleteResult = []
        self.tableView.reloadData()
//        self.setVisibleArea()
    }
    
    func resetDataSouce() {
        self.mapView.removeAnnotations(dataSource)
        self.dataSource = []
        
    }
    
    func showResult(results: [MKLocalSearchCompletion]) {
        self.searchView.isHidden = false
        tableViewDataSource?.autocompleteResult = results
        self.tableView.reloadData()
    }
}
extension IOSPlaceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotation = view.annotation?.coordinate else { return }
        print("didSelect annotation: ")
          
      }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { print("not MKUersLocation"); return nil }

        return annotationHandler.getAnnotation(mapView: mapView, annotation: annotation)
    }
}

extension IOSPlaceViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.resetDataSouce()
        self.hideResult()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { resetDataSouce(); return }
        self.searchCompleter.queryFragment = searchText
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

extension IOSPlaceViewController: LocationHandlerDelegate {
    func received(location: CLLocation) {
        print(location)
    }
    
    func locationDidFail(withError error: Error) {
        print("In Main View controller ", error)
    }
}
extension IOSPlaceViewController: ViewModelProtocol {
    func dataResult(places: [PlaceResult]) {
        print("data Result\n", places)
    }
    
    func didFailWithError(error: CustomError) {
        print("ViewModelProtocol: didFailWithError", error as Error)
    }
}
