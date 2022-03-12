//
//  ViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 11/22/21.
//

import SwiftUI

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var cocktailDrinks: [DrinkItem]?
    
    var cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: cellID)
        
        setupDrinks()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cocktailDrinks = cocktailDrinks {
            return cocktailDrinks.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DrinkCell
        cell.drinkItem = cocktailDrinks?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //detailVC.drinkItem = cocktailDrinks?[indexPath.item]
        detailVC.drinkId = cocktailDrinks?[indexPath.item].id
        detailVC.navigationItem.title = cocktailDrinks?[indexPath.item].name
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

extension ViewController {
    func setupDrinks() {
        Networking.getDrinks { categoryDrinks in
            self.cocktailDrinks = categoryDrinks.drinks
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
