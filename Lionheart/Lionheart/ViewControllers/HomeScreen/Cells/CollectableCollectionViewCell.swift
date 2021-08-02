//
//  CollectableCollectionViewCell.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import UIKit

class CollectableCollectionViewCell: UICollectionViewCell {
    private var collectableImageView = UIImageView()
    
    private var collectable: Collectable! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .red
        
        self.contentView.addSubview(collectableImageView)
        
        collectableImageView.contentMode = .scaleAspectFill
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectableImageView.translatesAutoresizingMaskIntoConstraints = false
        collectableImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        collectableImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        collectableImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        collectableImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}

extension CollectableCollectionViewCell {
    
    func loadCollectable(collectable: Collectable) {
        self.collectable = collectable
    }
    
    private func updateUI() {
        if collectable.image != nil {
            collectableImageView.image = collectable.image
        }
    }
    
    //MARK: Cell Transformations
    func transformToFocus() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
    
    func transformToOriginal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = .identity
        })
    }
}
