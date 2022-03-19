//
//  Networking.swift
//  DrinkMixer
//
//  Created by Jing Li on 12/31/21.
//

import Foundation
import UIKit

enum CategoryNameUrlString: String {
    case cocktail = "Cocktail"
    case ordinaryDrink = "Ordinary_Drink"
    case homemadeLiqueur = "Homemade_Liqueur"
    case punchPartyDrink = "Punch_/_Party Drink"
    case shake = "Shake"
    case cocoa = "Cocoa"
    case shot = "Shot"
    case beer = "Beer"
    case softDrink = "Soft_Drink"
    case coffeeTea = "Coffee_/_Tea"
}

class Networking {
    static func getDrinks(in category: String = "Ordinary_Drink", completion: @escaping (CategoryDrinks) -> Void ) {
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("URL datatask data is empty.")
                return
            }
            
            do {
                let categoryDrinks = try JSONDecoder().decode(CategoryDrinks.self, from: data)
                completion(categoryDrinks)
                
            } catch let err {
                print(err.localizedDescription)
            }
        }.resume()
    }
    
    static func loadThumbnailImageFromURLString(urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error   {
                print(error.localizedDescription)
                return
            }

            guard let data = data, let loadedImage = UIImage(data: data) else {
                print("No data or image retrieved.")
                return
            }
            
            completion(loadedImage)
        }.resume()
    }
    
    static func getDrinkDetail(by drinkId: String, completion: @escaping (DrinkItem?) -> Void) {
        
        guard drinkId.count != 0 else {
            print("DrinkId is empty.")
            return
        }
        
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drinkId)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Did not receive data for getDrinkDetail().")
                return
            }
            
            do {
                let categoryDrinks = try JSONDecoder().decode(CategoryDrinks.self, from: data)
                completion(categoryDrinks.drinks.first)
            } catch let err {
                print("Error when parsing JSON detailed drinkItem. " + err.localizedDescription)
            }
        }.resume()
    }
}
