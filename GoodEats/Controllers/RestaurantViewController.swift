//
//  ViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

class RestaurantViewController: UIViewController {
    // MARK: - Properties
    var restaurantIsVisited = Array(repeating: false, count: restaurants.count)
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 82
        tv.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.reuseId)
        tv.cellLayoutMarginsFollowReadableWidth = true
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
    
    // MARK: - Helpers
    func handleCheckInAccessoryView(forCellAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView = restaurants[indexPath.row].isVisited ? .none : UIImageView(image: UIImage(named: "heart-tick"))
        restaurants[indexPath.row].isVisited.toggle()
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
        cell.accessoryView = restaurants[indexPath.row].isVisited ? UIImageView(image: UIImage(named: "heart-tick")) : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        let callAction = UIAlertAction(title: "Call 123-000-\(indexPath.row)", style: .default) { (action) in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let checkInAction = UIAlertAction(title: restaurants[indexPath.row].isVisited ? "Undo Check in" : "Check In", style: .default) { (action) in
            self.handleCheckInAccessoryView(forCellAt: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(callAction)
        optionMenu.addAction(checkInAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            self.handleCheckInAccessoryView(forCellAt: indexPath)
            completionHandler(true)
        }
        checkInAction.backgroundColor = .systemGreen
        checkInAction.image = !restaurants[indexPath.row].isVisited ? UIImage(systemName: "checkmark") : UIImage(systemName: "arrow.uturn.left")
        
        return UISwipeActionsConfiguration(actions: [checkInAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            restaurants.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in " + restaurants[indexPath.row].name
            let activityViewController: UIActivityViewController
            
            if let imageToShare = UIImage(named: restaurants[indexPath.row].image) {
                activityViewController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityViewController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            if let popoverViewController = activityViewController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverViewController.sourceView = cell
                    popoverViewController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityViewController, animated: true, completion: nil)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor(red: 254/255, green: 149/255, blue: 38/255, alpha: 1)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
