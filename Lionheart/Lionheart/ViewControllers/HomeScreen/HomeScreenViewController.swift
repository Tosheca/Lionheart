//
//  HomeScreenViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import UIKit

var CELL_HORIZONTAL_SPACING: CGFloat {
    get {
        // Adjust horizontal spacing based on device
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        }
        else {
            return 40
        }
    }
}

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
        self.title = "Collectables"
        
        collectablesCollectionView.delegate = self
        collectablesCollectionView.dataSource = self
        collectablesCollectionView.showsHorizontalScrollIndicator = false
        
        collectablesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 2 * CELL_HORIZONTAL_SPACING, bottom: 0, right: 2 * CELL_HORIZONTAL_SPACING)
                
        fetchCollectables()
    }
    
    // MARK: Rotation of device
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            // called right after rotation transition ends
            self.view.setNeedsLayout()
            self.collectablesCollectionView.reloadData()
            self.selectFocusedCell()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectFocusedCell()
    }
}

extension HomeScreenViewController {
    // Fetches pre-downloaded data for testing purposes
    private func fetchCollectables() {
        let collectable1 = Collectable(image: UIImage(named: "dog"), title: "Dog", author: "TEmmyMik")
        let collectable2 = Collectable(image: UIImage(named: "cat"), title: "Cat", author: "taniuniyana")
        let collectable3 = Collectable(image: UIImage(named: "monkey"), title: "Monkey", author: "Subash BGK")
        let collectable4 = Collectable(image: UIImage(named: "fish"), title: "Fish", author: "Gracie Loo")
        let collectable5 = Collectable(image: UIImage(named: "bird"), title: "Bird", author: "Mathias Appel")
        let collectable6 = Collectable(image: UIImage(named: "horse"), title: "Horse", author: "Guy Frankland")
        let collectable7 = Collectable(image: UIImage(named: "lion"), title: "Lion", author: "Rebecca Kepich")
        let collectable8 = Collectable(image: UIImage(named: "tiger"), title: "Tiger", author: "Mathias Appel")
        
        collectables.append(collectable1)
        collectables.append(collectable2)
        collectables.append(collectable3)
        collectables.append(collectable4)
        collectables.append(collectable5)
        collectables.append(collectable6)
        collectables.append(collectable7)
        collectables.append(collectable8)
    }
    
    private func openCollectable(_ collectable: Collectable) {
        
        
        
        let imageHandlerVC = ImageHandlerViewController(collectable)
        self.navigationController?.pushViewController(imageHandlerVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenCollectable = collectables[indexPath.item]
        
        openCollectable(chosenCollectable)
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
