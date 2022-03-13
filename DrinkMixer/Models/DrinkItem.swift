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
    
    var ingredient1: String?
    var ingredient2: String?
    var ingredient3: String?
    var ingredient4: String?
    var ingredient5: String?
    var ingredient6: String?
    var ingredient7: String?
    var ingredient8: String?
    var ingredient9: String?
    var ingredient10: String?
    var ingredient11: String?
    var ingredient12: String?
    var ingredient13: String?
    var ingredient14: String?
    var ingredient15: String?
    
    var ingredientMeasure1: String?
    var ingredientMeasure2: String?
    var ingredientMeasure3: String?
    var ingredientMeasure4: String?
    var ingredientMeasure5: String?
    var ingredientMeasure6: String?
    var ingredientMeasure7: String?
    var ingredientMeasure8: String?
    var ingredientMeasure9: String?
    var ingredientMeasure10: String?
    var ingredientMeasure11: String?
    var ingredientMeasure12: String?
    var ingredientMeasure13: String?
    var ingredientMeasure14: String?
    var ingredientMeasure15: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case id = "idDrink"
        case imageURL = "strDrinkThumb"
        
        case category = "strCategory"
        case glass = "strGlass"
        case isAlchoholic = "strAlcoholic"
        
        //case ingredients = ""
        case instructions = "strInstructions"
        
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        
        case ingredientMeasure1 = "strMeasure1"
        case ingredientMeasure2 = "strMeasure2"
        case ingredientMeasure3 = "strMeasure3"
        case ingredientMeasure4 = "strMeasure4"
        case ingredientMeasure5 = "strMeasure5"
        case ingredientMeasure6 = "strMeasure6"
        case ingredientMeasure7 = "strMeasure7"
        case ingredientMeasure8 = "strMeasure8"
        case ingredientMeasure9 = "strMeasure9"
        case ingredientMeasure10 = "strMeasure10"
        case ingredientMeasure11 = "strMeasure11"
        case ingredientMeasure12 = "strMeasure12"
        case ingredientMeasure13 = "strMeasure13"
        case ingredientMeasure14 = "strMeasure14"
        case ingredientMeasure15 = "strMeasure15"
    }
}
