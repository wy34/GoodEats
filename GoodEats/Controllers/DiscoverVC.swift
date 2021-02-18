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
    private var imageCache = NSCache<CKRecord.ID, CloudRestaurant>()
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Discover")
        tv.cellLayoutMarginsFollowReadableWidth = true
        tv.tableFooterView = UIView()
        tv.refreshControl = UIRefreshControl()
        tv.refreshControl?.backgroundColor = .white
        tv.refreshControl?.tintColor = .gray
        tv.refreshControl?.addTarget(self, action: #selector(fetchRecordFromCloudOperationally), for: .valueChanged)
        return tv
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.style = .medium
        a.hidesWhenStopped = true
        return a
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Discover"
        layoutViews()
        spinner.startAnimating()
        fetchRecordFromCloudOperationally()
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubviews(tableView, spinner)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        spinner.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 150)
        spinner.center(to: view, by: .centerX)
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
                    
                    if let name = record.object(forKey: "name") as? String {
                        cloudRestaurant.name = name
                    }
                    
                    if let image = record.object(forKey: "image") as? CKAsset {
                        if let data = try? Data(contentsOf: image.fileURL!) {
                            cloudRestaurant.image = UIImage(data: data)
                        }
                    }
                    
                    return cloudRestaurant
                })

                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // Operational api is suitable for bigger amounts of data, provides more flexibility in downloading data (example: downloading specific pieces of data only)
    @objc func fetchRecordFromCloudOperationally() {
        cloudRestaurants.removeAll()
        tableView.reloadData()
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"] // specify the specific keys to fetch back, only specifiy name here to download it first and lazily download image
        queryOperation.queuePriority = .veryHigh // setting the execution priority
        queryOperation.resultsLimit = 50 // only 50 records are fetched at any one time
        
        
        queryOperation.recordFetchedBlock = { record in // this closure is called every time a record is fetched back
            let cloudRestaurant = CloudRestaurant()
            if let name = record.object(forKey: "name") as? String {
                cloudRestaurant.name = name
            }
            cloudRestaurant.recordId = record.recordID
            self.cloudRestaurants.append(cloudRestaurant)
        }
        
        queryOperation.queryCompletionBlock = { [weak self] (cursor, error) in // this closure is called after all records are fetched
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successflly retrieve the data from iCloud")
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.tableView.reloadData()
                
                if let refreshControl = self?.tableView.refreshControl { // ends refreshing otherwise it stays
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        publicDatabase.add(queryOperation)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Discover", for: indexPath)
        let cloudRestaurant = cloudRestaurants[indexPath.row]
        
        cell.textLabel?.text = cloudRestaurants[indexPath.row].name // at this point, name is already downloaded
        cell.imageView?.image = UIImage(systemName: "photo") // image is not, so we set placeholder
        cell.imageView?.tintColor = .black

        if let cloudRestaurant = imageCache.object(forKey: cloudRestaurant.recordId!) { // checking if image already exists
            cell.imageView?.image = cloudRestaurant.image
        } else {
            // fetch just image from cloud in background
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [cloudRestaurant.recordId!]) // specify a specific record to download
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh

            fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) in // gets called per record that is completed
                if let error = error {
                    print("Failed to get retaurant image: \(error.localizedDescription)")
                    return
                }

                if let image = record?.object(forKey: "image") as? CKAsset {
                    if let imageData = try? Data(contentsOf: image.fileURL!) {
                        cloudRestaurant.image = UIImage(data: imageData)
                        self.imageCache.setObject(cloudRestaurant, forKey: cloudRestaurant.recordId!) // saving into cache
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout() // becuase the placeholder image size is different than the one just downloaded
                        }
                    }
                }
            }

            publicDatabase.add(fetchRecordsImageOperation)
        }
        
        return cell
    }
}

