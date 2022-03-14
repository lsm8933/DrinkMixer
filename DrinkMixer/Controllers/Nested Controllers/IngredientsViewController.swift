//
//  IngredientsViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/13/22.
//

import UIKit

class IngredientsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: Properties
    var ingredientsToMeasure: [(String?, String?)]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.backgroundColor = .green
        
        collectionView.register(IngredientItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = ingredientsToMeasure?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IngredientItemCell
        if let ingredientsToMeasure = ingredientsToMeasure {
            ingredientItemCell.ingredientName = ingredientsToMeasure[indexPath.item].0
            ingredientItemCell.measure = ingredientsToMeasure[indexPath.item].1
        }
        return ingredientItemCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }
}


class IngredientItemCell: BaseCell {
    var measure: String? {
        didSet {
            measureLabel.text = measure
        }
    }
    var ingredientName: String? {
        didSet {
            ingredientNameLabel.text = ingredientName
        }
    }
    
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
