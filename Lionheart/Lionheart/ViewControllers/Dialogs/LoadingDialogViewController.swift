//
//  LoadingDialogViewController.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 9.08.21.
//

import UIKit

class LoadingDialogViewController: UIViewController {

    var loadingView = CustomProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
    }
    
    private func setup() {
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        self.view.addSubview(loadingView)
        
        loadingView.lineWidth = 0.15
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

extension LoadingDialogViewController {
    func startLoading(withDuration: TimeInterval) {
        loadingView.duration = withDuration
        loadingView.startAnimation()
    }
    
    func stopLoading() {
        loadingView.stopAnimation(completion: {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                self.view.removeFromSuperview()
            })
            
        })
    }
}
