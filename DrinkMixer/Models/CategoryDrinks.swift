//
//  CategoryDrinks.swift
//  DrinkMixer
//
//  Created by Jing Li on 12/31/21.
//

import Foundation

struct CategoryDrinks: Codable {
    var drinks: [DrinkItem]
    
    static func getPopularDrinks() -> CategoryDrinks {
                
        let categoryDrinks = CategoryDrinks(drinks: [
            DrinkItem(name: "French 75", id: "17197", imageURL: "https://www.thecocktaildb.com/images/media/drink/hrxfbl1606773109.jpg"),
            DrinkItem(name: "Manhattan", id: "11008", imageURL: "https://www.thecocktaildb.com/images/media/drink/yk70e31606771240.jpg"),
            DrinkItem(name: "Spritz", id: "17215", imageURL: "https://www.thecocktaildb.com/images/media/drink/j9evx11504373665.jpg"),
            DrinkItem(name: "Cosmopolitan", id: "17196", imageURL: "https://www.thecocktaildb.com/images/media/drink/kpsajh1504368362.jpg"),
            DrinkItem(name: "Pina Colada", id: "17207", imageURL: "https://www.thecocktaildb.com/images/media/drink/cpf4j51504371346.jpg"),
            DrinkItem(name: "Martini", id: "11728", imageURL: "https://www.thecocktaildb.com/images/media/drink/71t8581504353095.jpg"),
            DrinkItem(name: "Margarita", id: "11007", imageURL: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg"),
            DrinkItem(name: "Mojito", id: "11000", imageURL: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg"),
            DrinkItem(name: "Mai Tai", id: "11690", imageURL: "https://www.thecocktaildb.com/images/media/drink/twyrrp1439907470.jpg"),
            DrinkItem(name: "Mint Julep", id: "17206", imageURL: "https://www.thecocktaildb.com/images/media/drink/squyyq1439907312.jpg"),
            DrinkItem(name: "Old Fashioned", id: "11001", imageURL: "https://www.thecocktaildb.com/images/media/drink/vrwquq1478252802.jpg"),
            DrinkItem(name: "Mimosa", id: "17205", imageURL: "https://www.thecocktaildb.com/images/media/drink/juhcuu1504370685.jpg"),
            DrinkItem(name: "Long Island Iced Tea", id: "17204", imageURL: "https://www.thecocktaildb.com/images/media/drink/wx7hsg1504370510.jpg")
        ])
        
        return categoryDrinks
    }
}
