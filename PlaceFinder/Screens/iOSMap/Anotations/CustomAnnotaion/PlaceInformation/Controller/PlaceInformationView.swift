//
//  PlaceInformationView.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import MapKit
import UIKit
protocol PlaceInformationViewDelegate: AnyObject {
    func placeCoordinate(_ coordinate: CLLocationCoordinate2D)
}

class PlaceInformationView: UIView {
    func style() {
        layer.cornerRadius = frame.width/30
        layer.borderWidth = 1
        backgroundColor = UIColor.clear
        placeName.layer.cornerRadius = placeName.frame.height/4
        imageButton.layer.cornerRadius = imageButton.frame.height/20
        addressButton.layer.cornerRadius = addressButton.frame.height/4
        webButton.layer.cornerRadius = webButton.frame.height/4
        callButton.layer.cornerRadius = callButton.frame.height/4
        detailLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        placeName.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        placeName.layer.borderWidth = 1
        webButton.layer.borderWidth = 1
        callButton.layer.borderWidth = 1
        webButton.layer.borderWidth = 1
        imageButton.layer.borderWidth = 1
        addressButton.layer.borderWidth = 1
        detailLabel.layer.borderWidth = 1
        detailLabel.numberOfLines = 0
        detailLabel.layer.cornerRadius = detailLabel.frame.height/4
        self.detailLabel.preferredMaxLayoutWidth = self.bounds.size.width
        let mainScreen = MainScreen()
        let height = mainScreen.windowHeight*(0.5)
        let width = mainScreen.windowWidth*(0.85)
        frame = CGRect(x: 0, y: 0, width: width, height: height)
        center = CGPoint(x: 0, y: -height/2)
        /*
         let offset = CGPoint(x: image.size.width/2, y: -(image.size.height)/2)
                flagAnnotationView.centerOffset = offset
         */
    }
    
    @IBOutlet private weak var placeName: UILabel!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var webButton: UIButton!
    @IBOutlet private weak var callButton: UIButton!
    @IBOutlet private weak var addressButton: UIButton!
    @IBOutlet private weak var detailLabel: UILabel!
    private var url: URL?
    private var coordinnate: CLLocationCoordinate2D?
    weak var delegate: PlaceInformationViewDelegate?
    
    func confiure(annotation: CustomAnnotation) {
        self.coordinnate = annotation.coordinate
        imageButton.setImage(UIImage(named: "city")!, for: .normal)
        if let name = annotation.placeName {
            placeName.font = ( name.count >= 30) ? placeName.font.withSize(15) : placeName.font.withSize(17)
            placeName.text = name
        } else {
            placeName.removeFromSuperview()
        }
        
        if let url = annotation.url {
            self.url = url
            let strUrl = "\(String(describing: url))"
            var strUrlFilted = ""
            for char in strUrl {
                if char == "?" {
                    break
                }
                strUrlFilted.append(char)
            }
           
            webButton.setTitle(strUrlFilted, for: .normal)
            
        } else {
            webButton.removeFromSuperview()
        }
        
        if let address = annotation.address {
            addressButton.setTitle(address, for: .normal)
        } else {
            addressButton.removeFromSuperview()
        }
        
        if let phone = annotation.phone {
            callButton.setTitle(phone, for: .normal)
            
        } else {
            callButton.removeFromSuperview()
        }
        
        if let timeZone = annotation.timeZone {
            detailLabel.text = timeZone.description
        } else {
            detailLabel.removeFromSuperview()
        }
    }
    
    @IBAction func webAction(_ sender: AnyObject) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func callAction(_ sender: AnyObject) {
      
        guard let newString = callButton.titleLabel?.text else { return }
        let number = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .joined()
        print(number)
        
        if let url = URL(string: "tel://\(number)"),
        UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("Did Not work")
        }
    }
    
    @IBAction func goAction(_ sender: AnyObject) {
        print("Go")
        if let coordinnate = self.coordinnate {
            self.delegate?.placeCoordinate(coordinnate)
        }
    }
}
