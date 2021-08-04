//
//  ImageHandlerViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 3.08.21.
//

import UIKit

class ImageHandlerViewController: UIViewController {

    var draggedImages = [UIImage]()
    let layerImageView = DraggableLayerImageView(image: UIImage(named: "cat"))
    
    enum TopButtonType {
        case export
        case save
    }
    
    // MARK: Variables
    private var collectable: Collectable
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.backgroundColor = .green
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
        loadLayerImageView()
        
        setTopButtonTo(buttonType: .save)
    }
    
    
}

extension ImageHandlerViewController {
    @objc private func exportTapped() {

        
    }
    
    @objc private func saveTapped() {
        self.collectableImageView.image = ImageProcessor.mergeImageWithLayer(mainImageView: collectableImageView, layerImageView: layerImageView)
        
        setTopButtonTo(buttonType: .export)
    }
    
    private func loadLayerImageView() {
        
        layerImageView.contentMode = .scaleAspectFit
        layerImageView.isUserInteractionEnabled = true
        layerImageView.backgroundColor = .red
        
        var aspectR: CGFloat = 0.0

        aspectR = layerImageView.image!.size.width/layerImageView.image!.size.height
        self.view.addSubview(layerImageView)
        
        layerImageView.translatesAutoresizingMaskIntoConstraints = false
        layerImageView.widthAnchor.constraint(equalToConstant: 232).isActive = true
        layerImageView.heightAnchor.constraint(equalTo: layerImageView.widthAnchor, multiplier: 1/aspectR).isActive = true
        layerImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        layerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        draggedImages.append(layerImageView.image!)
    }
    
    private func loadCollectable() {
        if collectable.image != nil {
            collectableImageView.image = collectable.image
        }
    }
    
    private func setTopButtonTo(buttonType: TopButtonType) {
        if buttonType == .export {
            let exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportTapped))
            self.navigationItem.rightBarButtonItems = [exportButton]
        }
        else if buttonType == .save {
            let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
            self.navigationItem.rightBarButtonItems = [saveButton]
        }
    }
}
