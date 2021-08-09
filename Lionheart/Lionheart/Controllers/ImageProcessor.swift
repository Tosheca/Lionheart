//
//  ImageProcessor.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 4.08.21.
//

import Foundation
import UIKit

// Class used for image interaction and edit
class ImageProcessor {
    // MARK: Merging 2 images
    static func mergeImageWithLayer(mainImageView: UIImageView, layerImageView: UIImageView) -> UIImage? {
        // mainImageView reresents the image view of the foundational image
        // layerImageView repressents the layer "add on" to be merged onto mainImageView
        
        let ratio = mainImageView.image!.size.width / mainImageView.frame.size.width // used when calculating the actual image size. Allows working with the original size of the image
        
        let scale = layerImageView.transformScale // scale based on transformation. Useful when image is scaled up
        
        let size = CGSize(width: mainImageView.image!.size.width, height: mainImageView.image!.size.height)
        UIGraphicsBeginImageContext(size) // size of the foundation
        
        let size2 = CGSize(width: layerImageView.contentClippingRect.width * ratio * scale, height: layerImageView.contentClippingRect.height * ratio * scale) // size of the add on layer
        
        let area1 = CGRect(x: 0, y: 0, width: size.width, height: size.height) // area of the foundation
        
        let area2 = CGRect(x: (layerImageView.frame.origin.x - mainImageView.frame.origin.x) * ratio, y: (layerImageView.frame.origin.y - ((mainImageView.frame.height - mainImageView.contentClippingRect.height)/2 + mainImageView.frame.origin.y)) * ratio, width: size2.width, height: size2.height) // area of the add on layer
        
        mainImageView.image!.draw(in: area1)
        layerImageView.image!.draw(in: area2, blendMode: .normal, alpha: 1)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return finalImage
    }
}
