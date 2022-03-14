//
//  ViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 11/22/21.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: Properties
    var cocktailDrinks: [DrinkItem]?
    
    var cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //let layout = collectionViewLayout as! UICollectionViewFlowLayout
        //layout.minimumInteritemSpacing
        //layout.scrollDirection = .horizontal
        
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: cellID)
        
        setupDrinks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restoreTopBarAppearance()
    }
    
    // MARK: - UICollectionViewDataSource
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
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (collectionView.frame.width - 2 * 8 - 2 * 10) / 3
        let cellHeight: CGFloat = cellWidth / 3 * 5
        
        return CGSize(width: cellWidth, height: cellHeight)
        //return CGSize(width: 130, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    // MARK: - Private methods
    private func setupDrinks() {
        Networking.getDrinks { categoryDrinks in
            self.cocktailDrinks = categoryDrinks.drinks
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func restoreTopBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        //appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .default
    }
}
