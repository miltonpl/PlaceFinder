//
//  SearchPlaceViewModel.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import Foundation

// MARK: - View Model Protocol
protocol ViewModelProtocol: AnyObject {
    func dataResult(places: [PlaceResult])
    func placeDetailResult(place: ResultDetails, placeId: String)
}

// MARK: - Google View Contrller Protocol
protocol GoogleViewControllerProtocol: AnyObject {
    func handlePlaceSearch(text: String)
    func fetchPlaceInfoDetails(placeId: String)
    var delegate: ViewModelProtocol? { get set }
}

class ViewModel: GoogleViewControllerProtocol {
    
    weak var delegate: ViewModelProtocol?
    var searchWorkItem: DispatchWorkItem?

    func handlePlaceSearch(text: String) {
        print("text To search:", text)
        self.searchWorkItem?.cancel()
        self.searchWorkItem = DispatchWorkItem {
            self.fetchData(text)
        }
        guard let searchItem = searchWorkItem else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: searchItem)
    }
    // MARK: - Fetch Data Information From Google Place API
    func fetchData(_ text: String) {
        guard var urlComponents = URLComponents(string: GooglePlaces.BaseURL) else { return }
        var parameter = GooglePlaces.parameters
        parameter["query"] = text
        var elements: [URLQueryItem] = []
        for (key, value) in parameter {
            elements.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = elements
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        ServiceManager.manager.request(Place.self, withRequest: request) { result in
            switch result {
            case .success(let place):
                if let results = place.results {
                    self.delegate?.dataResult(places: results)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Fetch Place Detains From Google Place API
    func fetchPlaceInfoDetails(placeId: String) {
        guard var urlComponents = URLComponents(string: GooglePlaces.BaseURLDetail) else { return }
        var parameter = GooglePlaces.detailParameters
        parameter["place_id"] = placeId
        var elements: [URLQueryItem] = []
        for (key, value) in parameter {
            elements.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = elements
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = "GET"
        ServiceManager.manager.request(PlaceInfo.self, withRequest: request) { result in
            switch result {
            case .success(let place):
                if let placeDeatils = place.result {
                    self.delegate?.placeDetailResult(place: placeDeatils, placeId: placeId)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
