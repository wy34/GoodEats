//
//  RestaurantDetailViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit

class RestaurantDetailVC: UIViewController {
    // MARK: - Properties
    var restaurant: Restaurant?
    
    // MARK: - Views
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(RestaurantDetailIconTextCell.self, forCellReuseIdentifier: RestaurantDetailIconTextCell.reuseId)
        tv.register(RestaurantDetailTextCell.self, forCellReuseIdentifier: RestaurantDetailTextCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.separatorStyle = .none
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - UI
    func configureNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func layoutViews() {
        view.addSubviews(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
}

// MARK: - UITableView Delegate/Datasource
extension RestaurantDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RestaurantDetailVCHeaderView()
        headerView.restaurant = self.restaurant
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailIconTextCell.reuseId, for: indexPath) as! RestaurantDetailIconTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant, forPhone: true)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailIconTextCell.reuseId, for: indexPath) as! RestaurantDetailIconTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant, forPhone: false)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailTextCell.reuseId, for: indexPath) as! RestaurantDetailTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant)
                return cell
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
