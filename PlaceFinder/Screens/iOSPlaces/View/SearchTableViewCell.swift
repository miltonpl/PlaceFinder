//
//  SearchTableViewCell.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(place: PlaceDetails) {
        self.titleLabel.text = place.title
        self.subtitleLabel.text = place.subtitle
        self.subtitleLabel.isHidden = place.subtitle?.isEmpty ?? true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    static func nib() -> UINib {
        return UINib(nibName: "SearchTableViewCell", bundle: nil)
    }
    
}
