//
//  AnnotationTableViewCell.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/21/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class AnnotationTableViewCell: UITableViewCell {
    static let identifier = "AnnotationTableViewCell"
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(type: NameType, description: String) {
        self.typeLabel.text = type.rawValue.capitalized
        self.descriptionLabel.numberOfLines = 0
        if description.count >= 24 {
            self.descriptionLabel.font = descriptionLabel.font.withSize(15)
        }
        self.descriptionLabel.text = description
        
    }
    static func nib() -> UINib {
        return UINib(nibName: "AnnotationTableViewCell", bundle: nil)
    }
    
}
