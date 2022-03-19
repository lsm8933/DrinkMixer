//
//  HomeViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/18/22.
//

import UIKit

enum CategoryNameTitle: String {
    case cocktail = "Cocktail"
    case ordinaryDrink = "Ordinary Drink"
    case homemadeLiqueur = "Homemade Liqueur"
    case punchPartyDrink = "Punch / Party Drink"
    case shake = "Shake"
    case cocoa = "Cocoa"
    case shot = "Shot"
    case beer = "Beer"
    case softDrink = "Soft Drink"
    case coffeeTea = "Coffee / Tea"
}

class HomeViewController: UICollectionViewController {
    
    // MARK: Properties
    private let sectionHeaderId = "sectionHeaderId"
    private let smallCellId = "smallCellId"
    private let drinkCellId = "drinkCellId"
    
    var categoryNameToCategoryDrinks = [CategoryNameTitle: CategoryDrinks]()
    var popularCatetoryDrinks: CategoryDrinks?
    
    // MARK: - UICollectionViewCompositionalLayout
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
            switch sectionNumber {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 8)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = .init(top: 0, leading: 16, bottom: 32, trailing: 8) // top: 16 if has header
                
                return section
                
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(200)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 16, leading: 16, bottom: 32, trailing: 0)
                
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = .cyan
        
        collectionView.register(HomeCategoriesSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        collectionView.register(DrinkSmallCell.self, forCellWithReuseIdentifier: smallCellId)
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: drinkCellId)
        
        setupPopularDrinks()
        setupDrinks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restoreTopBarAppearance()
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 12
        default:
            if categoryNameToCategoryDrinks.count > 0 {
                return 10
            }
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderId, for: indexPath) as! HomeCategoriesSectionHeader
        switch indexPath.section {
        case 1:
            header.categoryNameTitle = .ordinaryDrink
        case 2:
            header.categoryNameTitle = .cocktail
        default:
            break
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! DrinkSmallCell
            cell.drinkItem = popularCatetoryDrinks?.drinks[indexPath.item]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinkCellId, for: indexPath) as! DrinkCell
            cell.drinkItem = categoryNameToCategoryDrinks[.ordinaryDrink]?.drinks[indexPath.item]
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinkCellId, for: indexPath) as! DrinkCell
            cell.drinkItem = categoryNameToCategoryDrinks[.cocktail]?.drinks[indexPath.item]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinkCellId, for: indexPath) as! DrinkCell
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailVC = DetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        var drinkItem: DrinkItem?
        
        switch indexPath.section {
        case 0:
            drinkItem = popularCatetoryDrinks?.drinks[indexPath.item]
        case 1:
            drinkItem = categoryNameToCategoryDrinks[.ordinaryDrink]?.drinks[indexPath.item]
        case 2:
            drinkItem = categoryNameToCategoryDrinks[.cocktail]?.drinks[indexPath.item]
        default:
            break
        }
        
        detailVC.drinkId = drinkItem?.id
        detailVC.navigationItem.title = drinkItem?.name
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Private methods
    private func setupPopularDrinks() {
        popularCatetoryDrinks = CategoryDrinks.getPopularDrinks()
        collectionView.reloadSections(IndexSet.init(integer: 0))
    }
    
    let dispatchGroup = DispatchGroup()
    
    private func setupDrinks() {
        
        dispatchGroup.enter()
        Networking.getDrinks(in: CategoryNameUrlString.ordinaryDrink.rawValue) { catetoryDrinks in
            //self.catetoryDrinks = catetoryDrinks
            self.categoryNameToCategoryDrinks[.ordinaryDrink] = catetoryDrinks
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Networking.getDrinks(in: CategoryNameUrlString.cocktail.rawValue) { catetoryDrinks in
            self.categoryNameToCategoryDrinks[.cocktail] = catetoryDrinks
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
        }
    }
    
    private func restoreTopBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .default
    }
}


class HomeCategoriesSectionHeader: UICollectionReusableView {
    var categoryNameTitle: CategoryNameTitle? {
        didSet {
            categoryNameLabel.text = categoryNameTitle?.rawValue
        }
    }
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .magenta
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryNameLabel)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
