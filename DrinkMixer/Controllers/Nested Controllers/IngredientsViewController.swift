//
//  IngredientsViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/13/22.
//

import UIKit

class IngredientsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.backgroundColor = .green
        
        collectionView.register(IngredientItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IngredientItemCell
        return ingredientItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }
}


class IngredientItemCell: BaseCell {
    var measure: String?
    var ingredientName: String?
    
    let measureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "1/2 oz"
        return label
    }()
    
    let ingredientNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Lime juice"
        return label
    }()
    
    override func setupViews() {
        //backgroundColor = .red
        
        addSubview(measureLabel)
        addSubview(ingredientNameLabel)

        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        measureLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
        measureLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        measureLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        measureLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        ingredientNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3).isActive = true
        ingredientNameLabel.leadingAnchor.constraint(equalTo: measureLabel.trailingAnchor).isActive = true
        ingredientNameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        ingredientNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
