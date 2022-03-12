//
//  BaseCell.swift
//  DrinkMixer
//
//  Created by Jing Li on 1/10/22.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        
    }
}
