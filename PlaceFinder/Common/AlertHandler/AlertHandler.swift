//
//  AlertHandler.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit
enum AlertButton: String {
// swiftlint:disable type_name superfluous_disable_command
// swiftlint:disable identifier_name
    case ok
    case cancel
    case settings
    case delete
}

protocol AlertHandlerProtocol: UIViewController {
    func showAlert(title: String, message: String, buttons: [AlertButton], complition: @escaping(UIAlertController, AlertButton) -> Void)
}

extension AlertHandlerProtocol {
    
    func showAlert(title: String, message: String, buttons: [AlertButton] = [.ok], complition: @escaping(UIAlertController, AlertButton) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        buttons.forEach { button in
            let action = UIAlertAction(title: button.rawValue.capitalized, style: (button == .delete) ? .destructive : .default) { [alert, button] _ in
                complition(alert, button)
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
