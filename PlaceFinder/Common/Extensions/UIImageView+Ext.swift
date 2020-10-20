//
//  UIImageView+Ext.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
extension UIImageView {
    func dowloadImage(url: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.image = Constants.failedImage
                }
            }
        }
    }
}
