//
//  UIView+Ext.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
extension UIView {
    class func viewNib(_ name: String) -> UIView? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? UIView
    }
    
}
