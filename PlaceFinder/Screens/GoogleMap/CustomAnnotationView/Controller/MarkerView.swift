//
//  MarkerView.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
enum InfoType: String {
    case phone
    case web
    case address
}

class MarkerView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 14
        }
    }
    @IBOutlet private weak var placeName: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.estimatedRowHeight = 100
            tableView.sizeToFit()
            tableView.register(AnnotationTableViewCell.nib(), forCellReuseIdentifier: AnnotationTableViewCell.identifier)
        }
    }
    typealias CommunicationType = (type: InfoType, description: String)
    var arrayData: [CommunicationType] =  []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initSubView() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
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
    
    func setCommunication(contact: CommunicationType) {
        switch contact.type {
        case .phone:
            print("phone")
            self.makeACall(phone: contact.description)
        case .web:
            print("web")
            self.goToPlaceWebsite(url: contact.description)
            
        case .address:
            print("Address")
        }
    }
    func goToPlaceWebsite(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    func makeACall(phone: String) {
        let number = phone.components(separatedBy: CharacterSet.decimalDigits.inverted)
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
}

extension MarkerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         arrayData.count
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setCommunication(contact: arrayData[indexPath.row])
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: AnnotationTableViewCell.identifier, for: indexPath) as? AnnotationTableViewCell else {
             fatalError("Unable to dequeue AnnotationTableViewCell")
         }
         let data = arrayData[indexPath.row]
        switch data.type {
        case .phone:
            cell.configure(image: UIImage(named: "callAnnotation"), description: data.description)
        case .web:
            cell.configure(image: UIImage(named: "webAnnotation"), description: data.description)
        case .address:
            cell.configure(image: UIImage(named: "markerAnnotation"), description: data.description)
        }
         return cell
     }
    
}
