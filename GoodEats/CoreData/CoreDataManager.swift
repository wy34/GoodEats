//
//  CoreDataManager.swift
//  GoodEats
//
//  Created by William Yeung on 2/13/21.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoodEats")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        
        return container
    }()

    func createRestaurantWith(name: String, type: String, location: String, phone: String, summary: String, image: UIImage) {
        let restaurant = Restaurant(context: persistentContainer.viewContext)
        restaurant.name = name
        restaurant.type = type
        restaurant.location = location
        restaurant.phone = phone
        restaurant.summary = summary
        restaurant.isCheckedIn = false
        restaurant.rating = ""
        
        if let data = image.pngData() {
            restaurant.image = data
        }
    }
    
    func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetch() -> [Restaurant] {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        do {
            let restaurants = try persistentContainer.viewContext.fetch(fetchRequest)
            return restaurants
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func delete(_ restaurant: Restaurant) {
        persistentContainer.viewContext.delete(restaurant)
    }
}
