//
//  DetailViewController.swift
//  DrinkMixer
//
//  Created by Jing Li on 3/4/22.
//

import UIKit

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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.backgroundColor = .red
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientsCell.self, forCellWithReuseIdentifier: ingredientsCellId)
        collectionView.register(InstructionCell.self, forCellWithReuseIdentifier: instructionCellId)
        
        // set inset of collection view to the sum of nav bar and status bar heights.
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

        let topBarHeight = statusBarFrame.height + navigationBarFrame.height
        collectionView.contentInset.top = -topBarHeight
        
        //collectionView.contentInsetAdjustmentBehavior = .never
 
        // transparant top bar, with white colored nav bar title text and barButton text.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
        
        // white text on status bar.
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: UICollectionView data source
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let detailHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath ) as! DetailHeader
        if let imageURL = drinkItem?.imageURL {
            detailHeader.headerImageView.loadImageFromUrlString(urlString: imageURL)
        }
        return detailHeader
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientsCellId, for: indexPath)
            return cell
        } else { //  if indexPath.item == 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: instructionCellId, for: indexPath) as! InstructionCell
            cell.instructionString = drinkItem?.instructions
            return cell
        }
    }
    
    // MARK: UICollectionView flowLayout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let dummyCell = InstructionCell(frame: .init(x: 0, y: 0, width: view.frame.width - 2 * 8, height: 1000))
            
            dummyCell.instructionString = drinkItem?.instructions
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width - 2 * 8, height: 1000))
            
            return .init(width: view.frame.width - 2 * 8, height: estimatedSize.height)
            
        } else {
            return CGSize(width: view.frame.width - 2 * 8, height: 400)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)
    }
    
    // MARK: UIScrollView delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = collectionView.contentOffset.y
        
        // get topBarHeight
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

        let topBarHeight = statusBarFrame.height + navigationBarFrame.height
        
        let headerHeight = view.frame.width
        
        // total scroll distance for top bar dark to light appearance transition.
        let offSetHeight = headerHeight - topBarHeight
        
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
}

class DetailHeader: BaseCell {
    
    let headerImageView: UrlImageView = {
        let iv = UrlImageView()
        iv.contentMode = .scaleAspectFill
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
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .systemCyan
    }
}
