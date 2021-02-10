//
//  Restaurant.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import Foundation

struct Restaurant {
    let image: String
    let name: String
    let location: String
    let type: String
    var isVisited = false
}

var restaurants = [
    Restaurant(image: "cafedeadend", name: "Cafe Deadend", location: "Hong Kong", type: "Coffee & Tea Shop"),
    Restaurant(image: "homei", name: "Homei", location: "Hong Kong", type: "Cafe"),
    Restaurant(image: "teakha", name: "Teakha", location: "Hong Kong", type: "Tea House"),
    Restaurant(image: "cafeloisl", name: "Cafe Loisl", location: "Hong Kong", type: "Austrian / Causual Drink"),
    Restaurant(image: "petiteoyster", name: "Petite Oyster", location: "Hong Kong", type: "French"),
    Restaurant(image: "forkeerestaurant", name: "For Kee Restaurant", location: "Hong Kong", type: "Bakery"),
    Restaurant(image: "posatelier", name: "Po's Atelier", location: "Hong Kong", type: "Bakery"),
    Restaurant(image: "bourkestreetbakery", name: "Bourke Street Bakery", location: "Sydney", type: "Chocolate"),
    Restaurant(image: "haighschocolate", name: "Haigh's Chocolate", location: "Sydney", type: "Cafe"),
    Restaurant(image: "palominoespresso", name: "Palomino Espresso", location: "Sydney", type: "American / Seafood"),
    Restaurant(image: "upstate", name: "Upstate", location: "New York", type: "American"),
    Restaurant(image: "traif", name: "Traif", location: "New York", type: "American"),
    Restaurant(image: "grahamavenuemeats", name: "Graham Avenue Meats And Deli", location: "New York", type: "Breakfast & Brunch"),
    Restaurant(image: "wafflewolf", name: "Waffle & Wolf", location: "New York", type: "Coffee & Tea"),
    Restaurant(image: "fiveleaves", name: "Five Leaves", location: "New York", type: "Coffee & Tea"),
    Restaurant(image: "cafelore", name: "Cafe Lore", location: "New York", type: "Latin American"),
    Restaurant(image: "confessional", name: "Confessional", location: "New York", type: "Spanish"),
    Restaurant(image: "barrafina", name: "Barrafina", location: "London", type: "Spanish"),
    Restaurant(image: "donostia", name: "Donostia", location: "London", type: "Spanish"),
    Restaurant(image: "royaloak", name: "Royal Oak", location: "London", type: "British"),
    Restaurant(image: "caskpubkitchen", name: "CASK Pub and Kitchen", location: "London", type: "Thai")
]
