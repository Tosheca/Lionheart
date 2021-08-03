//
//  ImageHandlerViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 3.08.21.
//

import UIKit

class ImageHandlerViewController: UIViewController {

    // MARK: Variables
    private var collectable: Collectable
    
    @IBOutlet weak var collectableImageView: UIImageView! {
        didSet {
            self.collectableImageView.contentMode = .scaleAspectFill
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
        
    }
    
    
}

extension ImageHandlerViewController {
    private func loadCollectable() {
        if collectable.image != nil {
            collectableImageView.image = collectable.image
        }
    }
}
