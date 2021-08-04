//
//  DraggableLayerImageView.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 3.08.21.
//

import UIKit

class DraggableLayerImageView: UIImageView {
    
    
    var dragStartPositionRelativeToCenter : CGPoint?
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer!) {
        if recognizer.state == UIGestureRecognizer.State.began {
            let locationInView = recognizer.location(in: superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            return
        }
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            dragStartPositionRelativeToCenter = nil
            
            return
        }
        
        let locationInView = recognizer.location(in: superview)
        
        UIView.animate(withDuration: 0.1) {
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                  y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
}
