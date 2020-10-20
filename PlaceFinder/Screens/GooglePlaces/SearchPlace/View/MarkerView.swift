//
//  MarkerView.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
class MarkerView: UIView {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    func confiure(marker: GMSPlaceMark) {
        self.nameLabel.text = marker.name
        self.nameLabel.numberOfLines = 0
        self.nameLabel.font = nameLabel.font.withSize(13)
        self.addressLabel.adjustsFontSizeToFitWidth = true
        self.addressLabel.numberOfLines = 0
        self.addressLabel.text = marker.address
    }
}
