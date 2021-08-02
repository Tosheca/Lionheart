//
//  CollectableCollectionViewCell.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import UIKit

class CollectableCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    private var collectableImageView: UIImageView = {
       let collectableImageView = UIImageView()
        collectableImageView.contentMode = .scaleAspectFill
        return collectableImageView
    }()
    
    private var infoView: UIView = {
        let infoView = UIView()
        return infoView
    }()
    
    private var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = .white
        infoLabel.textAlignment = .left
        infoLabel.font = UIFont.boldSystemFont(ofSize: 25)
        infoLabel.adjustsFontSizeToFitWidth = true
        return infoLabel
    }()
    
    private var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        authorLabel.textAlignment = .left
        authorLabel.font = UIFont.boldSystemFont(ofSize: 12)
        authorLabel.adjustsFontSizeToFitWidth = true
        return authorLabel
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        return gradientLayer
    }()
    
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
        
        infoView.addSubview(infoLabel)
        infoView.addSubview(authorLabel)
        
        self.contentView.addSubview(collectableImageView)
        self.contentView.addSubview(infoView)
                
        setupConstraints()
        
        addGradientInfoBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Updaing gradient bounds because of autolayout
        addGradientInfoBackground()
    }
    
    private func setupConstraints() {
        collectableImageView.translatesAutoresizingMaskIntoConstraints = false
        collectableImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        collectableImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        collectableImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        collectableImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        infoView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10).isActive = true
        authorLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.1).isActive = true
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        
        // Adjusting min height of the title
        let height = infoLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.15)
        let minHeight = infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        height.priority = .defaultHigh
        minHeight.priority = .required

        NSLayoutConstraint.activate([
            height, minHeight
        ])
    }
}

extension CollectableCollectionViewCell {
    
    func addGradientInfoBackground() {
        // Layout subviews in order to use bounds correctly
        self.layoutIfNeeded()
        
        // Updating the bounds every time the func is called to ensure autolayout
        gradientLayer.frame = infoView.bounds
        
        // Removes the previously based bounds gradient and applies the new one
        gradientLayer.removeFromSuperlayer()
        infoView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func loadCollectable(collectable: Collectable) {
        self.collectable = collectable
    }
    
    private func updateUI() {
        if collectable.image != nil {
            collectableImageView.image = collectable.image
        }
        
        infoLabel.text = collectable.title ?? ""
        
        if collectable.author != nil {
            authorLabel.text = "by " + collectable.author
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
