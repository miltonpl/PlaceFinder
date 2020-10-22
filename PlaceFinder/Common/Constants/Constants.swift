//
//  Constants.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

enum Constants {
    static let failedImage = UIImage(named: "Failed")!
    static let textSearhFormat = "https://maps.googleapis.com/maps/api/place/textsearch/output?parameters"
    static let nearByPlace: [NearByPlaces] = [.gasStation, .aquarium, .atm, .bakery, .bank, .bar, .gym, .airport]
}
enum GooglePlaces {
    static let googleKey = "AIzaSyBHA5l7bOlJdhz-5aybKOyLuAl9Nug6kv8"
    static let BaseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    
    static let parameters = [
        "query": "",
        "key": "AIzaSyBHA5l7bOlJdhz-5aybKOyLuAl9Nug6kv8"
    ]
    static let BaseURLDetail = "https://maps.googleapis.com/maps/api/place/details/json"
    static let detailParameters = [
        "place_id": "",
        "fields": "formatted_phone_number,website,formatted_address",
        "key": "AIzaSyBHA5l7bOlJdhz-5aybKOyLuAl9Nug6kv8"
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
