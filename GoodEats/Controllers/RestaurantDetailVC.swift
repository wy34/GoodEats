//
//  RestaurantDetailViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit
import MapKit


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
        tv.register(RestaurantDetailSeparatorCell.self, forCellReuseIdentifier: RestaurantDetailSeparatorCell.reuseId)
        tv.register(RestaurantDetailMapCell.self, forCellReuseIdentifier: RestaurantDetailMapCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    let tableHeaderView = RestaurantDetailVCHeaderView()
    let tableFooterView = RestaurantDetailRatingButtonView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
        
        if let rating = restaurant?.rating {
            tableHeaderView.ratingImageView.image = UIImage(named: rating)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - UI
    func configureNavBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func layoutViews() {
        view.addSubviews(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    func configureRatingImageView(withImage image: String?) {
        restaurant?.rating = image ?? ""
        CoreDataManager.shared.save()
        tableHeaderView.ratingImageView.image = UIImage(named: image ?? "")
        
        tableHeaderView.ratingImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: []) {
            self.tableHeaderView.ratingImageView.transform = .identity
        }
    }
}

// MARK: - UITableView Delegate/Datasource
extension RestaurantDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView.restaurant = self.restaurant
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailIconTextCell.reuseId, for: indexPath) as! RestaurantDetailIconTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant, forPhone: true)
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailIconTextCell.reuseId, for: indexPath) as! RestaurantDetailIconTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant, forPhone: false)
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailTextCell.reuseId, for: indexPath) as! RestaurantDetailTextCell
                cell.populateDataIntoViews(fromRestaurant: self.restaurant)
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailSeparatorCell.reuseId, for: indexPath) as! RestaurantDetailSeparatorCell
                cell.selectionStyle = .none
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailMapCell.reuseId, for: indexPath) as! RestaurantDetailMapCell
                cell.selectionStyle = .none
                cell.restaurant = self.restaurant
                return cell
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let mapVC = MapVC()
            mapVC.restaurant = restaurant
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableFooterView.delegate = self
        return tableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90
    }
}

// MARK: - RestaurantDetailRatingViewDelegate
extension RestaurantDetailVC: RestaurantDetailRatingViewDelegate {
    func presentRatingVC() {
        let ratingVC = RatingVC()
        ratingVC.restaurant = self.restaurant
        ratingVC.restaurantDetailVC = self
        ratingVC.modalPresentationStyle = .fullScreen
        ratingVC.modalTransitionStyle = .crossDissolve
        present(ratingVC, animated: true)
    }
}
