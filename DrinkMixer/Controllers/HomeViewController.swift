//
//  HomeViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/18/22.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    private let smallCellId = "smallCellId"
    
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(200)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets.leading = 16
            
            return section
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(DrinkSmallCell.self, forCellWithReuseIdentifier: smallCellId)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
