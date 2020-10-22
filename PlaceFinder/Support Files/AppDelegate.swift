//
//  AppDelegate.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
/*
 1.) MVVM Architecture Implementation - In progress
 2.) Custom Annotation View - working on
 3.) Core Location Framework Important Classes - CLLocationManager, CLLocation, CLGeocoder, CLPlacemark, CLLocationManagerDeleagate - done
 4.) Geocoding & Reverse Geocoding Implementation - done
 5.) MKLocalSearch, MKLocalSearchCompleter Implementation - done
 6.) Display results of MKLocalSearch on Maps - done
 7.) Display results of MKLocalSearchCompleter on Maps - done
 8.) Implementation of Google Maps and displaying a series of custom annotation on the Map- done
 */
import GoogleMaps
//import GooglePlaces
import UIKit
@available(iOS 13.0, *)
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GooglePlaces.googleKey)
//        GMSPlacesClient.provideAPIKey(GooglePlaces.googleKey)
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
