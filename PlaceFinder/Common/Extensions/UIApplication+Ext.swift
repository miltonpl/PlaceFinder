//
//  UIApplication+Ext.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit
extension UIApplication {
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url) { status in
                print("Open Settings\(status)")
            }
        } else {
            // Fallback on earlier versions
            UIApplication.shared.canOpenURL(url)
        }
    }
}
