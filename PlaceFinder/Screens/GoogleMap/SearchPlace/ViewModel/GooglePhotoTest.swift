//
//  GooglePhotoTest.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/3/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import GooglePlaces
class GooglePhotoTest {
    var placesClient = GMSPlacesClient()
    var imageView = UIImageView()
    var placeName: String?
    
    func test(placeId: String) {
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
        
        placesClient.fetchPlace(fromPlaceID: placeId,
                                 placeFields: fields,
                                 sessionToken: nil, callback: { (place: GMSPlace?, error: Error?) in
                                    if let error = error {
                                        print("An error occurred: \(error.localizedDescription)")
                                        return
                                    }
                                    if let place = place {
                                        // Get the metadata for the first photo in the place photo metadata list.
                                        let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                                        
                                        // Call loadPlacePhoto to display the bitmap and attribution.
                                        self.placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                                            if let error = error {
                                                print("Error loading photo metadata: \(error.localizedDescription)")
                                                return
                                            } else {
                                                // Display the first image and its attributions.
                                                self.imageView.image = photo
//                                                self.lblText?.attributedText = photoMetadata.attributions;
//                                                self.placeName = photoMetadata.attributions
                                                print(photoMetadata.attributions?.string ?? "None")
                                                print(photo ?? "No image")
                                            }
                                        })
                                    }
        })
    }
}
