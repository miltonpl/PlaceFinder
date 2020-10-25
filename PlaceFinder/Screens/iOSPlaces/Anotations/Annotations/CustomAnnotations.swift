//
//  CustomAnnotations.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
       var placeName: String?
       var details: String?
       var address: String?
       var phone: String?
       var url: URL?
        var timeZone: TimeZone?
       init(coordinate: CLLocationCoordinate2D, name: String, address: String) {
           self.coordinate =  coordinate
           self.placeName = name
           self.address = address
           super.init()
       }
       
       init(coordinate: CLLocationCoordinate2D) {
           self.coordinate = coordinate
           super.init()
       }
       
       init(coordinate: CLLocationCoordinate2D, mapItem: MKMapItem) {
        self.coordinate =  coordinate
        self.placeName = mapItem.name
        self.phone = mapItem.phoneNumber
        if let address = mapItem.placemark.title {
            self.address = address.replacingOccurrences(of: "United States", with: "US")
        }
        self.url = mapItem.url
        self.timeZone = mapItem.timeZone
        super.init()
    }
}

class GasStationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var rating: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, rating: Double) {
        self.rating = " Rating: \(rating)"
        self.coordinate =  coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}

class GasStationAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ATMAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isOpen: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, isOpen: String) {
        self.coordinate =  coordinate
        self.title = title
        self.subtitle = subtitle
        self.isOpen = isOpen
        super.init()
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
class ATMAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class AquariumAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isOpen: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, isOpen: String) {
        self.coordinate =  coordinate
        self.title = title
        self.subtitle = subtitle
        self.isOpen = isOpen
        super.init()
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
class AquariumAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class PizzaAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
      var title: String?
      var subtitle: String?
      var isOpen: String?
      
      init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, isOpen: String) {
          self.coordinate =  coordinate
          self.title = title
          self.subtitle = subtitle
          self.isOpen = isOpen
          super.init()
      }
      
      init(coordinate: CLLocationCoordinate2D) {
          self.coordinate = coordinate
          super.init()
      }
}
class PizzaAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
