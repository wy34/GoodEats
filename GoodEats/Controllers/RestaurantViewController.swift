//
//  ViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

class RestaurantViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 82
        tv.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.reuseId)
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }

    // MARK: - UI
    func layoutViews() {
        view.addSubviews(tableView)
        
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - UITableView Delegate/Datasource
extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.reuseId, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = restaurants[indexPath.row]
        return cell
    }
}
