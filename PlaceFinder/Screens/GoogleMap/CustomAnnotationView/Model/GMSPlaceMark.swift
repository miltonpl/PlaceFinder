//
//  GMSPlaceMark.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/6/20.
//  Copyright © 2020 Milton. All rights reserved.
//

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
