//
//  DrinkItem.swift
//  DrinkMixer
//
//  Created by Jing Li on 12/31/21.
//

import Foundation

struct DrinkItem: Codable {
    var name: String?
    var id: String?
    var imageURL: String?
    
    var category: String?
    var glass: String?
    var isAlchoholic: String?
    
    //var ingredients
    var instructions: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case id = "idDrink"
        case imageURL = "strDrinkThumb"
        
        case category = "strCategory"
        case glass = "strGlass"
        case isAlchoholic = "strAlcoholic"
        
        //case ingredients = ""
        case instructions = "strInstructions"
    }
}
