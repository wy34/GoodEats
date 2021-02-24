//
//  ViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit
import CoreData
import UserNotifications
import CloudKit

class FavoritesVC: UIViewController {
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
    
    var isSearching = false
    
    // MARK: - Views
    private var searchController: UISearchController!
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 90
        tv.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
        tv.cellLayoutMarginsFollowReadableWidth = true
        tv.tableFooterView = UIView()
        tv.backgroundColor = UIColor(named: "DarkMode")
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
        presentOnboarding()
        prepareNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - UI
    func presentOnboarding() {
        if !OnboardingManager.shared.isOldUser {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            present(WalkThruVC(collectionViewLayout: layout), animated: true, completion: nil)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = NSLocalizedString("GoodEats", comment: "GoodEats")
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: .plain, target: self, action: #selector(handleAddTapped))
        
        navigationController?.navigationBar.sizeToFit() // fixes the issue where a collapsed navbar is the default when searchController is present
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search Restaurants...", comment: "Search Restaurants...")
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
        let heartImageView = UIImageView(image: UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate))
        heartImageView.tintColor = UIColor(named: "InvertedDarkMode")
        
        cell?.accessoryView = fetchedResultController.object(at: indexPath).isCheckedIn ? .none : heartImageView
        fetchedResultController.object(at: indexPath).isCheckedIn.toggle()
        CoreDataManager.shared.save()
    }
    
    func filterContent(for searchText: String) {
        guard let restaurants = fetchedResultController.fetchedObjects else { return }
        
        searchedResults = restaurants.filter({
            if let name = $0.name, let location = $0.location, let type = $0.type {
                return name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText) || type.localizedCaseInsensitiveContains(searchText) // disregards case
            }
            return false
        })
    }
    
    func prepareNotification() {
        // only notify if we actually have restaurants
        if fetchedResultController.fetchedObjects!.count <= 0 {
            return
        }
        
        // picks a random restaurant
        let randomNum = Int.random(in: 0..<fetchedResultController.fetchedObjects!.count)
        let randomSuggestedRestaurant = fetchedResultController.fetchedObjects![randomNum]
        
        // creating the user notification
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Restaurant Recommendation", comment: "Restaurant Recommendation")
        content.subtitle = NSLocalizedString("Try new food today", comment: "Try new food today")
        
        let contentBodyPart1 = NSLocalizedString("I recommend you to check out", comment: "I recommend you to check out")
        let contentBodyPart2 = NSLocalizedString("The restaurant is one of your favorites. It is located at", comment: "The restaurant is one of your favorites. It is located at")
        let contentBodyPart3 = NSLocalizedString("Would you like to give it a try?", comment: "Would you like to give it a try?")
        
        content.body = contentBodyPart1 + " \(randomSuggestedRestaurant.name!). " + contentBodyPart2 + " \(randomSuggestedRestaurant.name!). " + contentBodyPart3
        content.sound = UNNotificationSound.default
        content.userInfo = ["phone": randomSuggestedRestaurant.phone!] // adding a piece of info to the underlying dictionary
        
        // adding image to notification
        let tempDirPath = NSTemporaryDirectory()
        let tempDirURL = URL(fileURLWithPath: tempDirPath, isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
        if let image = UIImage(data: randomSuggestedRestaurant.image! as Data) {
            try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
            if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
                content.attachments = [restaurantImage]
            }
        }
        
        // Creating custom notification actions and adding them to notification center (no functionalities at this point)
        let categoryId = "goodEats.restaurantActions"
        let laterAction = UNNotificationAction(identifier: "goodEats.cancel", title: NSLocalizedString("Later", comment: "Later"), options: [])
        let callAction = UNNotificationAction(identifier: "goodEats.call", title: NSLocalizedString("Reserve a table", comment: "Reserve a table"), options: [.foreground])
        let category = UNNotificationCategory(identifier: categoryId, actions: [laterAction, callAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryId // associate actions to this particular notification
        
        // trigger set for every 24 hours (86400 seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (24*60*60), repeats: true)
        let request = UNNotificationRequest(identifier: "goodEats.restaurantSuggestion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func saveRecordToCloud(restaurant: Restaurant!) {
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.summary, forKey: "description")
                
        // resize the image because we don't want to upload a super high resolution photo
        let originalImage = UIImage(data: restaurant.image!)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image!, scale: scalingFactor)!
        
        // write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileUrl = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileUrl)
        
        // create image asset for icloud
        let imageAsset = CKAsset(fileURL: imageFileUrl)
        record.setValue(imageAsset, forKey: "image")
        
        // get the public icloud database
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // save record to icloud
        publicDatabase.save(record) { (record, error) in
            try? FileManager.default.removeItem(at: imageFileUrl)
        }
    }
    
    func handleShare(indexPath: IndexPath) {
        let defaultText = NSLocalizedString("Just checking in at ", comment: "Just checking in at ") + (fetchedResultController.object(at: indexPath).name ?? "")
        let activityViewController: UIActivityViewController

        if let imageToShare = UIImage(data: fetchedResultController.object(at: indexPath).image ?? Data()) {
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

        present(activityViewController, animated: true, completion: nil)
    }
    
    func handleDiscover(indexPath: IndexPath) {
        // check to see if user is signed in to iCloud
        if let _ = FileManager.default.ubiquityIdentityToken {
            print("IS Signed in to iCloud")
            let restaurant = fetchedResultController.object(at: indexPath)
            self.saveRecordToCloud(restaurant: restaurant)
        }
        else {
            print("NOT Signed in to iCloud")
            let alertController = UIAlertController(title: NSLocalizedString("iCloud", comment: "iCloud"), message: NSLocalizedString("Please sign in to iCloud in order to share to Discover page.", comment: "Please sign in to iCloud in order to share to Discover page."), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Selectors
    @objc func handleAddTapped() {
        let addNewRestaurantVC = AddNewRestaurantVC()
        let navigationController = UINavigationController(rootViewController: addNewRestaurantVC)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate/Datasource
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedResults.count : fetchedResultController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        cell.restaurant = isSearching ? searchedResults[indexPath.row] : fetchedResultController.object(at: indexPath)
        
        let heartImageView = UIImageView(image: UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate))
        heartImageView.tintColor = UIColor(named: "InvertedDarkMode")
        
        if isSearching {
            cell.accessoryView = searchedResults[indexPath.row].isCheckedIn ? heartImageView : .none
        } else {
            cell.accessoryView = fetchedResultController.object(at: indexPath).isCheckedIn ? heartImageView : .none
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
        restaurantDetailVC.hidesBottomBarWhenPushed = true
        restaurantDetailVC.restaurant = isSearching ? searchedResults[indexPath.row] : fetchedResultController.object(at: indexPath)
        navigationController?.pushViewController(restaurantDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            self.handleCheckInAccessoryView(forCellAt: indexPath)
            completionHandler(true)
        }
        checkInAction.backgroundColor = .systemGreen
        checkInAction.image = !fetchedResultController.object(at: indexPath).isCheckedIn ? UIImage(systemName: "checkmark") : UIImage(systemName: "arrow.uturn.backward")
        
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
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, sourceView, completionHandler) in
            self?.handleShare(indexPath: indexPath)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor.init(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let discoverAction = UIContextualAction(style: .normal, title: "Discover") { (action, sourceView, completionHandler) in
            self.handleDiscover(indexPath: indexPath)
            completionHandler(true)
        }
        discoverAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        discoverAction.image = UIImage(systemName: "eyeglasses")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction, discoverAction])
    }
    
    // disables left and right swipe of cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        }
        
        return true
    }
    
    // creates preview and context menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath.row as NSCopying, previewProvider: {
            // instantiating the VC that we are previewing
            let restaurantDetailVC = RestaurantDetailVC()
            let selectedRestaurant = self.fetchedResultController.object(at: indexPath)
            restaurantDetailVC.restaurant = selectedRestaurant
            return restaurantDetailVC
        }) { actions in
            let checkInAction = UIAction(title: NSLocalizedString("Check-In", comment: "Check-In"), image: UIImage(systemName: "checkmark")) { action in
                self.fetchedResultController.object(at: indexPath).isCheckedIn = self.fetchedResultController.object(at: indexPath).isCheckedIn ? false : true
            }
            
            let discoverAction = UIAction(title: NSLocalizedString("Discover", comment: "Discover"), image: UIImage(systemName: "eyeglasses")) { [weak self] (action) in
                self?.handleDiscover(indexPath: indexPath)
            }
            
            let shareAction = UIAction(title: NSLocalizedString("Share", comment: "Share"), image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                self?.handleShare(indexPath: indexPath)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: "Delete"), image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                let restaurantToDelete = self.fetchedResultController.object(at: indexPath)
                CoreDataManager.shared.delete(restaurantToDelete)
                CoreDataManager.shared.save()
            }
            
            return UIMenu(title: "", children: [checkInAction, discoverAction, shareAction, deleteAction])
        }
        
        return configuration
    }
    
    // action to perform when preview is tapped (ie: enlarging the preview)
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let selectedRow = configuration.identifier as? Int else {
            print("Failed to retrieve the row number")
            return
        }
        
        let restaurantDetailVC = RestaurantDetailVC()
        let selectedRestaurant = fetchedResultController.fetchedObjects![selectedRow]
        restaurantDetailVC.restaurant = selectedRestaurant
        restaurantDetailVC.hidesBottomBarWhenPushed = true
        
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            self.show(restaurantDetailVC, sender: self)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension FavoritesVC: NSFetchedResultsControllerDelegate {
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
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
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
extension FavoritesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            self.isSearching = true
            filterContent(for: searchText)
        } else {
            self.isSearching = false
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        tableView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension FavoritesVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { // dismiss keyboard when trying to scroll during isSearching == true
        searchController.searchBar.resignFirstResponder()
    }
}
