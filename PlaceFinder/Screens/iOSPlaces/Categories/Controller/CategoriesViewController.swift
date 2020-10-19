//
//  CategoriesViewController.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/19/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
         didSet {
             self.tableView.delegate = self
             self.tableView.dataSource = self
             self.tableView.register(SearchTableViewCell.nib(), forCellReuseIdentifier: SearchTableViewCell.identifier)
         }
     }
    
    var nearByPlaces = [NearByPlaces]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nearByPlaces = Constants.nearByPlace
        tableView.reloadData()
        self.setupSettingAction()
    }
    func setupSettingAction () {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
    }
    // MARK: - Instantiate My CollectionView Controller
    @objc func doneAction(_ sender: UIBarButtonItem ) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem ) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let cell = tableView.cellForRow(at: indexPath) {
               cell.accessoryType = .checkmark
           }
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nearByPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as?
                  SearchTableViewCell else { fatalError("Unable to dequeueReusableCell: SearchTableViewCell ")}
        let place = PlaceDetails(title: self.nearByPlaces[indexPath.row].rawValue)
              cell.configure(place: place)
              return cell
    }
}
