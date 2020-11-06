//
//  PlaceInfo.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/6/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation

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
