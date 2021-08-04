//
//  ImageProcessor.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 4.08.21.
//

import Foundation
import UIKit

class ImageProcessor {
    static func mergeImageWithLayer(mainImageView: UIImageView, layerImageView: UIImageView) -> UIImage? {
        
        let size = CGSize(width: mainImageView.contentClippingRect.width, height: mainImageView.contentClippingRect.height)
        UIGraphicsBeginImageContext(size)
        
        let size2 = CGSize(width: layerImageView.contentClippingRect.width, height: layerImageView.contentClippingRect.height)
        
        let area1 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let area2 = CGRect(x: layerImageView.frame.origin.x - mainImageView.frame.origin.x, y: layerImageView.frame.origin.y - (mainImageView.contentClippingRect.minY + mainImageView.frame.origin.y), width: size2.width, height: size2.height)
        
        
        mainImageView.image!.draw(in: area1)
        layerImageView.image!.draw(in: area2, blendMode: .normal, alpha: 1)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return finalImage
    }
}
