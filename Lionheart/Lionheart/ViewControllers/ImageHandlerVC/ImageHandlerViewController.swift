//
//  ImageHandlerViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 3.08.21.
//

import UIKit

class ImageHandlerViewController: UIViewController {
    
    // MARK: Variables
    var CELL_HORIZONTAL_SPACING: CGFloat {
        get {
            // Adjust horizontal spacing based on device
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 20
            }
            else {
                return 10
            }
        }
    }
    
    private var layerImages = [UIImage(named: "wand"), UIImage(named: "crown"), UIImage(named: "football"), UIImage(named: "basketball")]
    
    private var draggedLayers = [UIImageView]() // All active layers are stored in here
    
    private var isEditingImage = false {
        didSet {
            setTopButtonType()
        }
    }
    
    private var collectable: Collectable
    
    @IBOutlet weak var binImageView: UIImageView!
    
    @IBOutlet weak var layersCollectionView: UICollectionView! {
        didSet {
            self.layersCollectionView.register(LayerCollectionViewCell.self, forCellWithReuseIdentifier: "LayerCollectionViewCell")
            self.layersCollectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            self.layersCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.layersCollectionView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var collectableImageView: UIImageView! {
        didSet {
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

// MARK: Collection View
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
    // When a layer is selected from the layer's collection view, creates a copy image view to become an interactive layer
    func didDragLayer(layer: UIImageView, fromPostion: CGPoint) {
        let layerImageView = DraggableLayerImageView(image: layer.image)
        layerImageView.frame.size = layer.frame.size
        layerImageView.center = self.view.convert(layer.center, from: layer.superview)
        layerImageView.center.y -= 50 // offsetting the copy layer to be better visible
        self.view.addSubview(layerImageView)
        
        layerImageView.delegate = self
        draggedLayers.append(layerImageView)
        
        isEditingImage = true
    }
}

// MARK: Draggable Layer Delegate
extension ImageHandlerViewController: DraggableLayerDelegate {
    func didDropLayer(_ layer: UIImageView, at: CGPoint) {
        if binImageView.frame.contains(at) {
            removeLayer(layer)
        }
    }
    
    private func removeLayer(_ layer: UIImageView) {
        for draggedLayerIndex in 0..<draggedLayers.count {
            if draggedLayers[draggedLayerIndex] == layer {
                draggedLayers.remove(at: draggedLayerIndex)
                layer.removeFromSuperview()
                
                return
            }
        }
    }
}
