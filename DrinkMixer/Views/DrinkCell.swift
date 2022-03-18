//
//  DrinkCell.swift
//  DrinkMixer
//
//  Created by Jing Li on 1/10/22.
//

import UIKit

class DrinkCell: BaseCell {
    var drinkItem: DrinkItem? {
        didSet {

            guard let drinkItem = drinkItem else {
                return
            }

            if let name = drinkItem.name {
                nameLabel.text = name
            }
            if let id = drinkItem.id {
                ingredientsLabel.text = id
            }
            if let imageURL = drinkItem.imageURL {
                drinkImageView.loadImageFromUrlString(urlString: imageURL)
            }
        }
    }
    
    var drinkImageView: UrlImageView = {
        let iv = UrlImageView()
        iv.image = UIImage(named: "drink_margarita")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Margarita"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        //label.backgroundColor = .systemPink
        return label
    }()
    
    var ingredientsLabel: UILabel = {
        let label = UILabel()
        //label.text = "Tequila, triple sec, lime juice, salt... something something something Tequila, triple sec, lime juice, salt... something something something Tequila, triple sec, lime juice, salt... something something something Tequila, triple sec, lime juice, salt... something something something Tequila, triple sec, lime juice, salt... something something something"
        label.text = "Tequila"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        //label.backgroundColor = .cyan
        label.numberOfLines = 2
        return label
    }()
    
    override func setupViews() {
        //backgroundColor = .red

        addSubview(drinkImageView)
        addSubview(nameLabel)
        addSubview(ingredientsLabel)
        
        drinkImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 10, width: frame.width, height: 20)
        
        if let text = ingredientsLabel.text {
            let ingredientsEstimatedSize = NSString(string: text).boundingRect(with: CGSize(width: frame.width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            if ingredientsEstimatedSize.height < 20 { // one line of text
                ingredientsLabel.frame = CGRect(x: 0, y: frame.width + 22, width: frame.width, height: 35)
            } else { // two lines of text
                ingredientsLabel.frame = CGRect(x: 0, y: frame.width + 30, width: frame.width, height: 35)
            }
        }
    }
}
