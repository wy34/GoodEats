//
//  ViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit
import CoreData

class RestaurantVC: UIViewController {
    // MARK: - Properties
    lazy var fetchedResultController: NSFetchedResultsController<Restaurant> = {
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        return frc
    }()
    
    var searchedResults = [Restaurant]()
    
    // MARK: - Views
    private var searchController: UISearchController!
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 90
        tv.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.reuseId)
        tv.cellLayoutMarginsFollowReadableWidth = true
        tv.tableFooterView = UIView()
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
        present(WalkThruController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil), animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - UI
    func configureNavBar() {
        title = "GoodEats"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let largeCustomFont = UIFont(name: "Rubik-Medium", size: 40) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: largeCustomFont, NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60)]
        }
        
        if let smallCustomFont = UIFont(name: "Rubik-Medium", size: 16) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: smallCustomFont, NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60)]
        }
                
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddTapped))
        
        navigationController?.navigationBar.sizeToFit() // fixes the issue where a collapsed navbar is the default when searchController is present
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurants..."
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60) // cursor
        navigationItem.searchController = searchController
    }
    
    func layoutViews() {
        view.addSubviews(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }

    // MARK: - Helpers
    func handleCheckInAccessoryView(forCellAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView = fetchedResultController.object(at: indexPath).isCheckedIn ? .none : UIImageView(image: UIImage(named: "heart-tick"))
        fetchedResultController.object(at: indexPath).isCheckedIn.toggle()
    }
    
    func filterContent(for searchText: String) {
        guard let restaurants = fetchedResultController.fetchedObjects else { return }
        
        searchedResults = restaurants.filter({
            if let name = $0.name, let location = $0.location {
                return name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
            }
            return false
        })
    }
    
    // MARK: - Selectors
    @objc func handleAddTapped() {
        let addNewRestaurantVC = AddNewRestaurantVC()
        let navigationController = UINavigationController(rootViewController: addNewRestaurantVC)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate/Datasource
extension RestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchedResults.count : fetchedResultController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.reuseId, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = searchController.isActive ? searchedResults[indexPath.row] : fetchedResultController.object(at: indexPath)
        
        if searchController.isActive {
            cell.accessoryView = searchedResults[indexPath.row].isCheckedIn ? UIImageView(image: UIImage(named: "heart-tick")) : .none
        } else {
            cell.accessoryView = fetchedResultController.object(at: indexPath).isCheckedIn ? UIImageView(image: UIImage(named: "heart-tick")) : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return EmptyView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if fetchedResultController.sections![section].numberOfObjects == 0 {
            return UIScreen.main.bounds.height * 0.5
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let restaurantDetailVC = RestaurantDetailVC()
        restaurantDetailVC.restaurant = searchController.isActive ? searchedResults[indexPath.row] : fetchedResultController.object(at: indexPath)
        navigationController?.pushViewController(restaurantDetailVC, animated: true)
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//        
//        // for ipads
//        if let popoverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//        
//        let callAction = UIAlertAction(title: "Call 123-000-\(indexPath.row)", style: .default) { (action) in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//        
//        let checkInAction = UIAlertAction(title: restaurants[indexPath.row].isCheckedIn ? "Undo Check in" : "Check In", style: .default) { (action) in
//            self.handleCheckInAccessoryView(forCellAt: indexPath)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(checkInAction)
//        optionMenu.addAction(cancelAction)
//        present(optionMenu, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            self.handleCheckInAccessoryView(forCellAt: indexPath)
            completionHandler(true)
        }
        checkInAction.backgroundColor = .systemGreen
        checkInAction.image = !fetchedResultController.object(at: indexPath).isCheckedIn ? UIImage(systemName: "checkmark") : UIImage(systemName: "arrow.uturn.left")
        
        return UISwipeActionsConfiguration(actions: [checkInAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            let restaurantToDelete = self.fetchedResultController.object(at: indexPath)
            CoreDataManager.shared.delete(restaurantToDelete)
            CoreDataManager.shared.save()
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.init(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(systemName: "trash")
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in " + (self.fetchedResultController.object(at: indexPath).name ?? "")
            let activityViewController: UIActivityViewController
            
            if let imageToShare = UIImage(data: self.fetchedResultController.object(at: indexPath).image ?? Data()) {
                activityViewController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityViewController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            // for ipads
            if let popoverViewController = activityViewController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverViewController.sourceView = cell
                    popoverViewController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityViewController, animated: true, completion: nil)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor.init(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    // disables left and right swipe of cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }
        
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension RestaurantVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if !searchController.isActive {
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        default:
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - UISearchResultsUpdating
extension RestaurantVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { // calls whenever searchController is interacted (first tapped, each search letter, cancel)
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}
