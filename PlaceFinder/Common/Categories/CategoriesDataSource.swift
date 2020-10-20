//
//  CategoriesDataSource.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/20/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit
class CategoriesDataSourc: UIViewController {
    var autocompleteResult = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               self.tableView.delegate = self
               self.tableView.dataSource = self
               self.tableView.register(SearchTableViewCell.nib(), forCellReuseIdentifier: SearchTableViewCell.identifier)
           }
       }
    
     func geocodingResult(localSearch: MKLocalSearchCompletion) {
            let placeName = localSearch.title
            let plceAddress = localSearch.subtitle
    //        let searchRequest = MKLocalSearch.Request(completion: localSearch)
    //        let search = MKLocalSearch(request: searchRequest)
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(plceAddress) { placeMark, error in
                if error == nil {
                    if let coordinates = placeMark?.first?.location?.coordinate {
                        print("coordinates ", coordinates)
                        DispatchQueue.main.async {
                           let annotation = CustomAnnotation(coordinate: coordinates, title: placeName, subtitle: plceAddress)
                            print(annotation)
                            
//                            self.mapView.addAnnotations([annotation])
//                            print("mapView Anotations, ", self.mapView.annotations)
                        }
                    }
                }
            }
        }
}

extension CategoriesDataSourc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        geocodingResult(localSearch: autocompleteResult[indexPath.row])
//        self.hideResult()
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
