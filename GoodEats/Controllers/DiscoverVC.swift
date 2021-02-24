//
//  DiscoverVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit
import CloudKit

class DiscoverVC: UIViewController {
    // MARK: - Properties
    var cloudRestaurants = [CloudRestaurant]()
    var tempCloudRestaurants = [CloudRestaurant]()
    
    // MARK: - Views
    let customLoadViewLauncher = CustomLoadViewLauncher()

    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(DiscoverRestaurantCell.self, forCellReuseIdentifier: DiscoverRestaurantCell.reuseId)
        tv.cellLayoutMarginsFollowReadableWidth = true
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        tv.backgroundColor = UIColor(named: "DarkMode")
        tv.addSubview(refreshControl)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = UIColor(named: "InvertedDarkMode")
        refreshControl.addTarget(self, action: #selector(fetchRecordFromCloudOperationally), for: .valueChanged)
        return tv
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
        handleLoad()
    }
    
    // MARK: - UI
    func configureNavBar() {
        navigationItem.title = NSLocalizedString("Discover", comment: "Discover")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: .plain, target: self, action: #selector(handleLoad))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // Convenient api is suitable for small pieces of data, downloads record wholly
    func fetchRecordsFromCloudConveniently() {
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)

        publicDatabase.perform(query, inZoneWith: nil) { [weak self] (results, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let results = results {
                print("Completed the download of Restaurant data")
                
                self?.cloudRestaurants = results.map({ record in
                    let cloudRestaurant = CloudRestaurant()
                    
                    cloudRestaurant.recordId = record.recordID
                    
                    if let location = record.object(forKey: "location") as? String {
                        cloudRestaurant.location = location
                    }
                    
                    if let description = record.object(forKey: "description") as? String {
                        cloudRestaurant.summary = description
                    }
                    
                    if let name = record.object(forKey: "name") as? String {
                        cloudRestaurant.name = name
                    }
                    
                    if let phone = record.object(forKey: "phone") as? String {
                        cloudRestaurant.phone = phone
                    }
                    
                    if let type = record.object(forKey: "type") as? String {
                        cloudRestaurant.type = type
                    }
                    
                    if let image = record.object(forKey: "image") as? CKAsset {
                        if let data = try? Data(contentsOf: image.fileURL!) {
                            cloudRestaurant.image = UIImage(data: data)
                        }
                    }
                    
                    return cloudRestaurant
                })

                DispatchQueue.main.async {
//                    self?.spinner.stopAnimating()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // Operational api is suitable for bigger amounts of data, provides more flexibility in downloading data (example: downloading specific pieces of data only)
    @objc func fetchRecordFromCloudOperationally() {
        tableView.reloadData() // calling here to avoid the massive space created by the refresh controller for some reason
        tableView.isScrollEnabled = false
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "image", "type", "location", "description", "phone"] // specify the specific keys to fetch back, only specifiy name here to download it first and lazily download image
        queryOperation.queuePriority = .veryHigh // setting the execution priority
        queryOperation.resultsLimit = 50 // only 50 records are fetched at any one time
        
        queryOperation.recordFetchedBlock = { record in // this closure is called every time a record is fetched back
            let cloudRestaurant = CloudRestaurant()
            
            cloudRestaurant.recordId = record.recordID
            
            if let location = record.object(forKey: "location") as? String {
                cloudRestaurant.location = location
            }
            
            if let description = record.object(forKey: "description") as? String {
                cloudRestaurant.summary = description
            }
            
            if let name = record.object(forKey: "name") as? String {
                cloudRestaurant.name = name
            }
            
            if let phone = record.object(forKey: "phone") as? String {
                cloudRestaurant.phone = phone
            }
            
            if let type = record.object(forKey: "type") as? String {
                cloudRestaurant.type = type
            }
            
            if let image = record.object(forKey: "image") as? CKAsset {
                if let data = try? Data(contentsOf: image.fileURL!) {
                    cloudRestaurant.image = UIImage(data: data)
                }
            }
            
            self.tempCloudRestaurants.append(cloudRestaurant)
        }
        
        queryOperation.queryCompletionBlock = { [weak self] (cursor, error) in // this closure is called after all records are fetched
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successflly retrieve the data from iCloud")
            DispatchQueue.main.async {
                self?.cloudRestaurants.removeAll()
                self?.cloudRestaurants = self!.tempCloudRestaurants
                self?.tempCloudRestaurants.removeAll()
                self?.tableView.reloadData()
                self?.tableView.isScrollEnabled = true
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.customLoadViewLauncher.dismissCustomLoadView()

                if ((self?.refreshControl.isRefreshing) != nil) {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        
        publicDatabase.add(queryOperation)
    }
    
    // MARK: - Selectors
    @objc func handleLoad() {
        // shows the table in the background as empty
        cloudRestaurants.removeAll()
        tableView.reloadData()
        // shows the custom load screen
        customLoadViewLauncher.showCustomLoadView()
        // fetch data
        fetchRecordFromCloudOperationally()
    }
}

// MARK: - UITableview Delegate/Datasource
extension DiscoverVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverRestaurantCell.reuseId, for: indexPath) as! DiscoverRestaurantCell
        cell.cloudRestaurant = cloudRestaurants[indexPath.row]
        return cell
    }
}
