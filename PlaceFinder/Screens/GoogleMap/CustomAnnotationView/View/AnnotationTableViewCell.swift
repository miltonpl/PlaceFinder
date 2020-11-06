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
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        // Configure the view for the selected state
    }
    
    func configure(image: UIImage?, description: String) {
        self.itemImageView.image = image
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
