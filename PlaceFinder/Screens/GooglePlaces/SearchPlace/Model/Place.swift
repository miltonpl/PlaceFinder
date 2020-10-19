//
//  Place.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import CoreLocation

struct Destination {
    var keyword: String?
    var location: Coordinates?
    var destinationCoordinate: Coordinates?
    var radius: Int?
    var zoom: Double?
    var nextPageToken: String?
}

struct Place: Decodable {
    var results: [PlaceResult]?
    var status: String?
}

struct PlaceResult: Decodable {
    var businessStatus: String?
    var address: String?
    var geometry: Geometry?
    var icon: String?
    var name: String?
    var openingHours: OpeningHours?
    var placeId: String?
    var plusCode: PlusCode?
    var rating: Double?
    var reference: String?
    var placeDetail: [String]?
    var totalUserRatings: Int?
    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case address = "formatted_address"
        case geometry
        case icon
        case name
        case openingHours = "opening_hours"
        case placeId = "place_id"
        case plusCode = "plus_code"
        case rating
        case reference
        case placeDetail = "types"
        case totalUserRatings = "user_ratings_total"
    }
}

struct OpeningHours: Decodable {
    var openNow: Bool
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Geometry: Decodable {
    var location: Coordinates?
}

struct PlusCode: Decodable {
    var compoundCode: String?
    var globalCode: String?
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

struct Coordinates: Decodable {
    var lat: Double
    var lng: Double
    var cordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
