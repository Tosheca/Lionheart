//
//  HomeScreenViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import UIKit

class HomeScreenViewController: RootViewController {
    
    // MARK: Variables
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

    var focusedCell = CollectableCollectionViewCell()
    
    var collectables = [Collectable]()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectFocusedCell()
    }
}

extension HomeScreenViewController {
    // MARK: Fetching Collectables
    private func fetchCollectables() {
        self.startLoading(withDuration: 5.0)
        CollectablesDataFetcher.fetchCollectables(completion: { fetchedCollectables in
            DispatchQueue.main.async {
                self.collectables = fetchedCollectables
                self.collectablesCollectionView.reloadData()
            }
            self.stopLoading()
        })
    }
    
    // MARK: Open Collectable
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
                if visibleCell != focusedCell { // ensures optimization (only enters once)
                    focusedCell.transformToOriginal()
                    focusedCell = visibleCell as! CollectableCollectionViewCell
                    focusedCell.transformToFocus()
                    
                    return
                }
            }
        }
    }
}
