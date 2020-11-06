//
//  LocalSearchComplition.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 11/5/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import MapKit
protocol LocalSearchCompletionDelegate: AnyObject {
    func result(_ localSearchCompletion: [MKLocalSearchCompletion])
}

class LocalSearchCompletion: NSObject {
    public weak var delegate: LocalSearchCompletionDelegate?
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchC = MKLocalSearchCompleter()
        searchC.delegate = self
        return searchC
    }()
    
    init(text: String) {
        super.init()
        searchCompleter.queryFragment = text
    }
}

extension LocalSearchCompletion: MKLocalSearchCompleterDelegate {
    
     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.delegate?.result(completer.results)
     }
     
     func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
         print(error.localizedDescription)
     }
}
