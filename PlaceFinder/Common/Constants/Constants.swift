//
//  Constants.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation
enum Constants {
    static let textSearhFormat = "https://maps.googleapis.com/maps/api/place/textsearch/output?parameters"
    static let nearByPlace: [NearByPlaces] = [.gasStation, .aquarium, .atm, .bakery, .bank, .bar, .gym, .airport]
}
enum GooglePlaces {
    static let googleKey = "API key"
    static let BaseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    static let parameters = [
        "query": "",
        "key": "API key"
    ]
}

enum NearByPlaces: String {
    case airport = "Airport"
    case aquarium = "Aquarium"
    case atm = "ATM"
    case bakery = "Bakery"
    case bank = "Bank"
    case bar = "Bar"
    case gasStation = "Gas Station"
    case gym = "Gym"
}