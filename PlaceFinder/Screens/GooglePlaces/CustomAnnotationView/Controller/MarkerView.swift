//
//  MarkerView.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
enum NameType: String {
    case phone
    case web
    case name
    case address
}
/*
 override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
 }
 */
class MarkerView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var placeName: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.sizeToFit()
            tableView.register(AnnotationTableViewCell.nib(), forCellReuseIdentifier: AnnotationTableViewCell.identifier)
        }
    }
    var arrayData: [(name: NameType, description: String)] =  []
    
    func confiure(marker: GMSPlaceMark) {
        placeName.text = "None"
        if let name = marker.name {
            if name.count >= 30 {
                placeName.font = placeName.font.withSize(15)
            }
            placeName.text = name
        }
        if let phone = marker.phone {
            arrayData.append(( .phone, phone))
        }
        if let web = marker.website {
            arrayData.append(( .web, web))
        }
        if let address = marker.address {
            arrayData.append(( .address, address))
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnnotationTableViewCell.identifier, for: indexPath) as? AnnotationTableViewCell else {
            fatalError("Unable to dequeue AnnotationTableViewCell")
        }
        let data = arrayData[indexPath.row]
        cell.configure(type: data.name, description: data.description)
        return cell
    }
}
