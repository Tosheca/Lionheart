//
//  RootViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 9.08.21.
//

import UIKit

class RootViewController: UIViewController {

    private var loadingDialogViewController = LoadingDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
    }
    

    private func setup() {
        
    }
}

extension RootViewController {
    func startLoading(withDuration: TimeInterval) {
        self.view.addSubview(loadingDialogViewController.view)
        loadingDialogViewController.startLoading(withDuration: withDuration)
    }
    
    func stopLoading() {
        loadingDialogViewController.stopLoading()
    }
}
