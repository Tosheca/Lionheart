//
//  ImageHandlerViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 3.08.21.
//

import UIKit

class ImageHandlerViewController: UIViewController {
    
    // MARK: Variables
    private var layerImages = [UIImage(named: "wand"), UIImage(named: "crown"), UIImage(named: "football"), UIImage(named: "basketball")]
    
    private var draggedLayers = [UIImageView]()
    
    enum TopButtonType {
        case export
        case save
    }
    
    private var isEditingImage = false {
        didSet {
            setTopButtonType()
        }
    }
    
    private var collectable: Collectable
    
    @IBOutlet weak var layersCollectionView: UICollectionView! {
        didSet {
            self.layersCollectionView.register(LayerCollectionViewCell.self, forCellWithReuseIdentifier: "LayerCollectionViewCell")
            self.layersCollectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var collectableImageView: UIImageView! {
        didSet {
            self.collectableImageView.contentMode = .scaleAspectFill
            self.collectableImageView.isUserInteractionEnabled = true
            self.collectableImageView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: Init
    init(_ collectable: Collectable) {
        self.collectable = collectable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCollectable()
    }
    
    private func setup() {
        
        self.layersCollectionView.delegate = self
        self.layersCollectionView.dataSource = self
        
        setTopButtonType()
    }
}

extension ImageHandlerViewController {
    
    // MARK: Exporting/Sharing image
    @objc private func exportTapped() {
        // set up activity view controller
        let imageToShare = [collectableImageView.image!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    // MARK: Merging edits with image
    @objc private func saveTapped() {
        for layer in draggedLayers {
            self.collectableImageView.image = ImageProcessor.mergeImageWithLayer(mainImageView: collectableImageView, layerImageView: layer)
            layer.removeFromSuperview()
        }
        
        isEditingImage = false
    }
    
    private func loadCollectable() {
        if collectable.image != nil {
            collectableImageView.image = collectable.image
        }
    }
    
    // Switching top button depending on the state of the image. Save must always happen before export!
    private func setTopButtonType() {
        if isEditingImage == false {
            let exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportTapped))
            self.navigationItem.rightBarButtonItems = [exportButton]
        }
        else if isEditingImage == true {
            let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
            self.navigationItem.rightBarButtonItems = [saveButton]
        }
    }
}

extension ImageHandlerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CELL_HORIZONTAL_SPACING
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayerCollectionViewCell", for: indexPath) as? LayerCollectionViewCell {
            cell.delegate = self
            
            let currentLayer = layerImages[indexPath.item]
            cell.loadLayerImage(image: currentLayer!)
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
}

// MARK: Layer Cell Delegate
extension ImageHandlerViewController: LayerCellDelegate {
    func didDragLayer(layer: UIImageView, fromPostion: CGPoint) {
        let layerImageView = DraggableLayerImageView(image: layer.image)
        layerImageView.frame.size = layer.frame.size
        layerImageView.center = self.view.convert(layer.center, from: layer.superview)
        self.view.addSubview(layerImageView)
        
        draggedLayers.append(layerImageView)
        
        isEditingImage = true
    }
}
