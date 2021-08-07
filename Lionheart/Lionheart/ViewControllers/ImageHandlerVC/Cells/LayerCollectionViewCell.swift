//
//  LayerCollectionViewCell.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 5.08.21.
//

import UIKit

class LayerCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    var delegate: LayerCellDelegate?
    
    private var layerImageView: UIImageView = {
        let collectableImageView = UIImageView()
        collectableImageView.contentMode = .scaleAspectFit
        return collectableImageView
    }()
    
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
        
        self.contentView.addSubview(layerImageView)
                
        setupConstraints()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
    }
    
    private func setupConstraints() {
        layerImageView.translatesAutoresizingMaskIntoConstraints = false
        layerImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        layerImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        layerImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        layerImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
    }
}

extension LayerCollectionViewCell {
    func loadLayerImage(image: UIImage) {
        layerImageView.image = image
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let locationInView = sender.location(in: superview)
        self.delegate?.didDragLayer(layer: self.layerImageView, fromPostion: locationInView)
    }
}

protocol LayerCellDelegate {
    func didDragLayer(layer: UIImageView, fromPostion: CGPoint)
}
