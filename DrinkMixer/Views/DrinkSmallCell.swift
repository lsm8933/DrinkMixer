//
//  DrinkSmallCell.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/20/22.
//

import UIKit
import SDWebImage

class DrinkSmallCell: BaseCell {
    var drinkItem: DrinkItem? {
        didSet {
            nameLabel.text = drinkItem?.name
            
            if let imageUrl = drinkItem?.imageURL {
                drinkImageView.sd_setImage(with: URL(string: imageUrl))
            }
        }
    }
    
    let drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "drink_margarita")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Margarita and friends"
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    override func setupViews() {
        
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(drinkImageView)
        stackView.addArrangedSubview(nameLabel)
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        drinkImageView.heightAnchor.constraint(equalTo: drinkImageView.widthAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill // drinkImageView's height equal to stackview's height
        //stackView.distribution = .fill
        
        //stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 6
        stackView.clipsToBounds = true
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": stackView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": stackView]))
    }
}
