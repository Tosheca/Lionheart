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
        
        let size = CGSize(width: mainImageView.image!.size.width, height: mainImageView.image!.size.height)
        UIGraphicsBeginImageContext(size)
        
        let ratio = mainImageView.image!.size.width / mainImageView.frame.size.width
        let scale = layerImageView.transformScale
        let size2 = CGSize(width: layerImageView.contentClippingRect.width * ratio * scale, height: layerImageView.contentClippingRect.height * ratio * scale)
        
        let area1 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        print(mainImageView.frame.height)
        print(mainImageView.contentClippingRect.height)
        let area2 = CGRect(x: (layerImageView.frame.origin.x - mainImageView.frame.origin.x) * ratio, y: (layerImageView.frame.origin.y - ((mainImageView.frame.height - mainImageView.contentClippingRect.height)/2 + mainImageView.frame.origin.y)) * ratio, width: size2.width, height: size2.height)
        
        
        mainImageView.image!.draw(in: area1)
        layerImageView.image!.draw(in: area2, blendMode: .normal, alpha: 1)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return finalImage
    }
}
