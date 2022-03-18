//
//  HomeViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/18/22.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    private let sectionHeaderId = "sectionHeaderId"
    private let smallCellId = "smallCellId"
    
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in

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
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderId, for: indexPath)
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath)
        return cell
    }
    
}

class DrinkSmallCell: BaseCell {
    override func setupViews() {
        backgroundColor = .red
    }
}

class HomeCategoriesSectionHeader: UICollectionReusableView {
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
