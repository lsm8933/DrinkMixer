//
//  HomeViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/18/22.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    // MARK: Properties
    private let sectionHeaderId = "sectionHeaderId"
    private let smallCellId = "smallCellId"
    private let drinkCellId = "drinkCellId"

    let drinkCategories: [DrinkCategory] = [
        .popular, .cocktail, .ordinaryDrink, .punchPartyDrink, .shake, .shot, .homemadeLiqueur, .beer, .softDrink, .coffeeTea, .cocoa, .otherUnknown
    ]
    
    var drinkCategoryToCategoryDrinks = [DrinkCategory: CategoryDrinks]()
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
    
    // MARK: - UICollectionViewController
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
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 12
        default:
            if drinkCategoryToCategoryDrinks.count > 0 {
                let drinkCategory = drinkCategories[section]
                let numberOfResultsInCategory = drinkCategoryToCategoryDrinks[drinkCategory]?.drinks.count
                
                return min(15, numberOfResultsInCategory ?? 0)
            }
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderId, for: indexPath) as! HomeCategoriesSectionHeader
        
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            break
        case 1..<12:
            header.drinkCategory = drinkCategories[sectionNumber]
        default:
            break
        }
        header.delegate = self
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! DrinkSmallCell
            cell.drinkItem = popularCatetoryDrinks?.drinks[indexPath.item]
            return cell
            
        case 1..<12:
            let drinkCategory = drinkCategories[sectionNumber]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drinkCellId, for: indexPath) as! DrinkCell
            cell.drinkItem = drinkCategoryToCategoryDrinks[drinkCategory]?.drinks[indexPath.item]
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
        case 1..<12:
            let drinkCategory = drinkCategories[indexPath.section]
            drinkItem = drinkCategoryToCategoryDrinks[drinkCategory]?.drinks[indexPath.item]
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
        for i in 1..<12 {
            let drinkCategory = drinkCategories[i]

            dispatchGroup.enter()
            Networking.getDrinks(in: drinkCategory.toUrlString) { catetoryDrinks in
                self.drinkCategoryToCategoryDrinks[drinkCategory] = catetoryDrinks
                self.dispatchGroup.leave()
            }
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

extension HomeViewController: HomeCategoriesSectionHeaderDelegate {
    func moreButtonTapped(category: DrinkCategory) {
        let viewController = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
        viewController.drinkCategory = category
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol HomeCategoriesSectionHeaderDelegate: AnyObject {
    func moreButtonTapped(category: DrinkCategory)
}


class HomeCategoriesSectionHeader: UICollectionReusableView {
    weak var delegate: HomeCategoriesSectionHeaderDelegate?
    
    var drinkCategory: DrinkCategory? {
        didSet {
            categoryNameLabel.text = drinkCategory?.toTitleString
        }
    }
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .systemTeal
        label.text = "Category"
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    let moreButton: UIButton = {
        let btn = UIButton()
        
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))
        let arrowImage = UIImage(systemName: "arrow.forward", withConfiguration: configuration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        btn.setImage(arrowImage, for: .normal)
        
//        btn.layer.borderColor = UIColor.red.cgColor
//        btn.layer.borderWidth = 2
        
        btn.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .magenta
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        moreButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [categoryNameLabel, moreButton])
        stackView.spacing = 10
        //stackView.distribution = .fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreButtonTapped() {
        guard let drinkCategory = drinkCategory else {
            return
        }
        delegate?.moreButtonTapped(category: drinkCategory)
    }
}
