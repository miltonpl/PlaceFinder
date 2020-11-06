//
//  CompletionTableViewCell.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/6/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class CompletionTableViewCell: UITableViewCell {
    
    static let identifier = "CompletionTableViewCell"
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
        return UINib(nibName: "CompletionTableViewCell", bundle: nil)
    }
}
