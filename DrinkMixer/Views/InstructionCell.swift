//
//  InstructionCell.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/7/22.
//

import UIKit

class InstructionCell: BaseCell {
    
    var instructionString: String? {
        didSet {
            //print(instructionString)
            showReadableInstruction(rawInstructionText: instructionString)
        }
    }
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Instructions"
        label.font = .boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = ""
        
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //backgroundColor = .lightGray
                
        addSubview(descriptionLabel)
        addSubview(instructionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-16-[v1]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": instructionLabel, "v1" : descriptionLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": instructionLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": descriptionLabel]))
//        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        descriptionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func showReadableInstruction(rawInstructionText: String?) {
        guard let rawInstructionText = rawInstructionText else {
            return
        }
        
        if rawInstructionText == "" {
            descriptionLabel.text = "💔 Hmmm. Seems like the instruction for mixing this drink is not yet in theCocktailDB database."
            return
        }
        
        let splittedInstructionString = rawInstructionText.split(separator: ".", maxSplits: 20, omittingEmptySubsequences: true)
        
        var preparedInstructionString = "🍷 "
        preparedInstructionString += splittedInstructionString.joined(separator: ".\n\n🍷")
        preparedInstructionString.append(".")

        descriptionLabel.text = preparedInstructionString
    }
}
