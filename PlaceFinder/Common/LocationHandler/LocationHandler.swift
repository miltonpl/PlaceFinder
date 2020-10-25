//
//  LocationHandler.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationHandlerProtocol: AlertHandlerProtocol {
    func received(location: CLLocation)
    func locationDidFail(withError error: Error)
}

class LocationHandler: NSObject {
    
    private  lazy var locationManager: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.delegate = self
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        locationM.pausesLocationUpdatesAutomatically = true
        locationM.distanceFilter = 5
        locationM.showsBackgroundLocationIndicator = true
        return locationM
    }()
    
    weak var delegate: LocationHandlerProtocol?
    // MARK: - Init(delegate: LocationHandlerDelegate)
    init(delegate: LocationHandlerProtocol) {
        self.delegate = delegate
        super.init()
    }
     // MARK: - Get User Location
    func getUserLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            let title = "Location Disabled"
            let message = "Please enable your location service"
            delegate?.showAlert(title: title, message: message, buttons: [.cancel, .settings]) { _, type in
                switch type {
                case .settings:
                    UIApplication.shared.openSettings()
                case .cancel:
                    print("cancel")

                default:
                    break
                }
            }
            return
        }
        self.checkAndProntLocationAuthorization()
    }
     // MARK: - Check and Pronto location Authorization
    func checkAndProntLocationAuthorization() {
        let title = "Location Denied"
        let message = "Please give access to your location"
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            print("//notDetermined")
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("//restricted, .denied:")
            delegate?.showAlert(title: title, message: message, buttons: [.cancel, .settings]) { _, type in
                switch type {
                case .settings:
                    UIApplication.shared.openSettings()
                default:
                    break
                }
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            //get the user location
            self.locationManager.startUpdatingLocation()
            print("//authorizedAlways, .authorizedWhenInUse:")
            
        @unknown default:
            break
        }
    }
}
 // MARK: - CLLocationManagerDelegate
extension LocationHandler: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
          self.locationManager.stopUpdatingLocation()
        delegate?.received(location: location)
      }
    
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationDidFail(withError: error)
      }
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          print("locationManager status: ", status.rawValue)
      }
}
