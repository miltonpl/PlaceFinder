//
//  Place.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import CoreLocation
import GoogleMaps
class GMSPlaceMark: GMSMarker {
    var name: String?
    var address: String?
    var phone: String?
    var website: String?
    init(name: String, placeDetails: ResultDetails?, coordinate: Coordinates) {
        super.init()
        self.name = name
        self.address = placeDetails?.address
        self.phone = placeDetails?.phone
        if let website = placeDetails?.website {
            var web = ""
            for letter in website {
                if letter == "?" {
                    break
                }
                web.append(letter)
            }
            if !web.isEmpty {
                self.website = web
            }
        }
        position = coordinate.cordinates

        groundAnchor = CGPoint(x: 0.5, y: 2.0)
        appearAnimation = .pop
    }
}

struct PlaceInfo: Decodable {
    var result: ResultDetails?
}

struct ResultDetails: Decodable {
    var address: String?
    var phone: String?
    var website: String?
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case phone = "formatted_phone_number"
        case website = "website"
    }
}

struct Place: Decodable {
    var results: [PlaceResult]?
    var status: String?
   
}

struct PlaceResult: Decodable {
    var businessStatus: String?
    var address: String?
    var geometry: Geometry?
    var iconUrl: String?
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
        case iconUrl = "icon"
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
