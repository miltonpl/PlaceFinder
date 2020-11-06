//
//  CustomAnnotationView.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import MapKit
import UIKit

class CustomAnnotationView: MKAnnotationView {
    
    var placeInformationView: PlaceInformationView?
    weak var delegate: PlaceInformationViewDelegate?
    
    override var annotation: MKAnnotation? {
        willSet {
            placeInformationView?.removeFromSuperview()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected( selected, animated: animated)
        setUpPlaceInformationView(selected: selected)
    }
    
    func setUpPlaceInformationView(selected: Bool) {
        
        if selected {
            placeInformationView?.removeFromSuperview()
            let nibName = "PlaceInformationView"
            guard let placeInformationView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? PlaceInformationView,
                let customAnnotation = self.annotation as? CustomAnnotation else { return }
            
            placeInformationView.confiure(annotation: customAnnotation)
            placeInformationView.style()
            placeInformationView.delegate = self.delegate
            self.placeInformationView = placeInformationView
            
            self.addSubview(placeInformationView)
            self.bringSubviewToFront(placeInformationView)
        } else {
            placeInformationView?.removeFromSuperview()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if hitView == nil && self.isSelected {
            let pointInCallout = convert(point, to: placeInformationView)
            hitView = placeInformationView!.hitTest(pointInCallout, with: event)
        }
        if let callout = placeInformationView {
            if hitView == nil && self.isSelected {
                hitView = callout.hitTest(point, with: event)
            }
        }
        return hitView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeInformationView?.removeFromSuperview()
    }
}
