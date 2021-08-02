//
//  HomeScreenViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import UIKit

let CELL_HORIZONTAL_SPACING: CGFloat = 40

class HomeScreenViewController: UIViewController {

    var focusedCell = CollectableCollectionViewCell()
    
    var collectables = [Collectable]()
    
    // MARK: Variables
    @IBOutlet weak var collectablesCollectionView: UICollectionView! {
        didSet {
            self.collectablesCollectionView.register(CollectableCollectionViewCell.self, forCellWithReuseIdentifier: "CollectableCollectionViewCell")
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
    }
    
    private func setup() {
        collectablesCollectionView.delegate = self
        collectablesCollectionView.dataSource = self
        collectablesCollectionView.showsHorizontalScrollIndicator = false
        
        collectablesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 2 * CELL_HORIZONTAL_SPACING, bottom: 0, right: 2 * CELL_HORIZONTAL_SPACING)
                
        fetchCollectables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectFocusedCell()
    }
}

extension HomeScreenViewController {
    private func fetchCollectables() {
        let collectable1 = Collectable(image: UIImage(named: "dog"), title: "Dog", author: "Teodor Pavlov")
        let collectable2 = Collectable(image: UIImage(named: "cat"), title: "Cat", author: "Teodor Pavlov")
        let collectable3 = Collectable(image: UIImage(named: "monkey"), title: "Monkey", author: "Teodor Pavlov")
        let collectable4 = Collectable(image: UIImage(named: "fish"), title: "Fish", author: "Teodor Pavlov")
        
        collectables.append(collectable1)
        collectables.append(collectable2)
        collectables.append(collectable3)
        collectables.append(collectable4)
    }
}

// MARK: Collection View
extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 4 * CELL_HORIZONTAL_SPACING, height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5 * CELL_HORIZONTAL_SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectableCollectionViewCell", for: indexPath) as? CollectableCollectionViewCell {
            
            let currentCollectable = collectables[indexPath.item]
            cell.loadCollectable(collectable: currentCollectable)
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectFocusedCell()
    }
    
    private func selectFocusedCell() {
        // For all visible cells, checks which contains the center point of the view. Makes it focused.
        let visibleCells = collectablesCollectionView.visibleCells
        
        for visibleCell in visibleCells {
            let convertedRect = visibleCell.convert(visibleCell.bounds, to: self.view)

            if convertedRect.contains(self.view.center) {
                focusedCell.transformToOriginal()
                focusedCell = visibleCell as! CollectableCollectionViewCell
                focusedCell.transformToFocus()
            }
        }
    }
}
