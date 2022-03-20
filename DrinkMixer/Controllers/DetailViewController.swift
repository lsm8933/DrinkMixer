//
//  DetailViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/4/22.
//

import UIKit
import SDWebImage

class DetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    var drinkId: String? {
        didSet {
            guard let drinkId = drinkId else {
                return
            }
            
            if drinkItem != nil {
                return
            }

            Networking.getDrinkDetail(by: drinkId) { drinkItem in
                self.drinkItem = drinkItem
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    var drinkItem: DrinkItem?
    
    private let headerId = "headerId"
    private let ingredientsCellId = "ingredientsCellId"
    private let instructionCellId = "instructionCellId"
    
    private var headerHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = view.frame.width * 3 / 4
        
        //collectionView.backgroundColor = .red
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientsCell.self, forCellWithReuseIdentifier: ingredientsCellId)
        collectionView.register(InstructionCell.self, forCellWithReuseIdentifier: instructionCellId)
        
        setupTopBarAppearance()
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let detailHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath ) as! DetailHeader
        if let imageURL = drinkItem?.imageURL {
            detailHeader.headerImageView.sd_setImage(with: URL(string: imageURL))
        }
        return detailHeader
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientsCellId, for: indexPath) as! IngredientsCell
            cell.ingredientsViewController.ingredientsToMeasure = drinkItem?.ingredientsToMeasure
            return cell
        } else { //  if indexPath.item == 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: instructionCellId, for: indexPath) as! InstructionCell
            cell.instructionString = drinkItem?.instructions
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight ?? view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let dummyCell = InstructionCell(frame: .init(x: 0, y: 0, width: view.frame.width - 2 * 8, height: 1000))
            
            dummyCell.instructionString = drinkItem?.instructions
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width - 2 * 8, height: 1000))
            
            return .init(width: view.frame.width - 2 * 8, height: estimatedSize.height)
        } else { // indexPath.item == 0
            let dummyCell = IngredientsCell(frame: .init(x: 0, y: 0, width: view.frame.width - 2 * 8, height: 1000))
            
            dummyCell.ingredientsViewController.ingredientsToMeasure = drinkItem?.ingredientsToMeasure
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width - 2 * 8, height: 1000))
            
            return CGSize(width: view.frame.width - 2 * 8, height: estimatedSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = collectionView.contentOffset.y
        
        let topBarHeight = getTopBarHeight()
        
        // total scroll distance for top bar dark to light appearance transition.
        let offSetHeight = headerHeight ?? view.frame.width - topBarHeight
        
        // offset ratio.
        var offSet = abs(contentOffsetY) / offSetHeight
        
        if offSet > 1 {
            offSet = 1
        }
        
        // set status bar text color.
        if offSet < 0.5 {
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.barStyle = .black
        } else {
            navigationController?.navigationBar.overrideUserInterfaceStyle = .light
            navigationController?.navigationBar.barStyle = .default
        }
        
        let topBarBackgroundColor = UIColor(white: 1, alpha: offSet)
        let navBarTextColor = UIColor(hue: 1, saturation: 0, brightness: 1 - offSet, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance.backgroundColor = topBarBackgroundColor

        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: navBarTextColor]
        navigationController?.navigationBar.tintColor = navBarTextColor
    }
    
    // MARK: - Private methods
    /// setup status bar and nav bar with clear background and white text color.
    private func setupTopBarAppearance() {
        // move collection view up to beneath the nav bar and status bar.
        let topBarHeight = getTopBarHeight()
        collectionView.contentInset.top = -topBarHeight
 
        // transparant top bars, with white colored nav bar title text and barButton text.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        // white text on status bar.
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.barStyle = .black
    }
    
    /// returns the sum of nav bar height and status bar height
    private func getTopBarHeight() -> CGFloat {
        let statusBarFrame: CGRect
        let navigationBarFrame: CGRect

        if #available(iOS 13.0, *) {
            let keyWindowScene = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }.first
            statusBarFrame = keyWindowScene?.statusBarManager?.statusBarFrame ?? .zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }

        navigationBarFrame = navigationController?.navigationBar.frame ?? .zero

        return statusBarFrame.height + navigationBarFrame.height
    }
}

class DetailHeader: BaseCell {
    
    let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //iv.image = UIImage(named: "drink_margarita")
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //backgroundColor = .blue
        
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : headerImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : headerImageView]))
    }
}

class IngredientsCell: BaseCell {
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    let ingredientsViewController = IngredientsViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupViews() {
        super.setupViews()
        
        //backgroundColor = .systemCyan
                
        addSubview(headerLabel)
        addSubview(ingredientsViewController.collectionView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsViewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": headerLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ingredientsViewController.collectionView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-16-[v1]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": headerLabel, "v1": ingredientsViewController.collectionView!]))
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        //self.contentView.frame = self.bounds
        contentView.layoutIfNeeded()
        
        let nestedCollectionViewSize =  ingredientsViewController.collectionView.contentSize
        
        return CGSize(width: nestedCollectionViewSize.width, height: nestedCollectionViewSize.height + 8 + 16 + 8 + headerLabel.intrinsicContentSize.height)
    }
}
