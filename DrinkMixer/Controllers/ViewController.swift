//
//  ViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 11/22/21.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    // MARK: Properties
    var drinkCategory: DrinkCategory? {
        didSet {
            setupDrinks(category: drinkCategory)
        }
    }
    
    var allCocktailDrinks: [DrinkItem]?
    var cocktailDrinks: [DrinkItem]?
    
    var cellID = "cellID"
    
    var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UICollectionViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: cellID)
        
        setupSearch()
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
    
    // MARK: - UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let allCocktailDrinks = allCocktailDrinks else {
            return
        }
        
        if searchText == "" {
            resetToFullDrinksCollection()
            return
        }
        
        cocktailDrinks = allCocktailDrinks.filter({ drinkItem in
            guard let name = drinkItem.name else {
                return false
            }
            
            return name.localizedCaseInsensitiveContains(searchText)
        })
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetToFullDrinksCollection()
    }
    
    // MARK: - Private methods
    fileprivate func setupDrinks(category: DrinkCategory?) {
        guard let category = category else {
            return
        }
        
        navigationItem.title = category.toTitleString
        let categoryUrlString = category.toUrlString
        
        Networking.getDrinks(in: categoryUrlString) { categoryDrinks in
            self.allCocktailDrinks = categoryDrinks.drinks
            self.cocktailDrinks = self.allCocktailDrinks
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func resetToFullDrinksCollection() {
        cocktailDrinks = allCocktailDrinks
        collectionView.reloadData()
    }
    
    fileprivate func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        // navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    fileprivate func restoreTopBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .default
    }
}
