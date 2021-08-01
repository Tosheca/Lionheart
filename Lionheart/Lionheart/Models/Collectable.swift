//
//  Collectable.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import Foundation
import UIKit

class Collecatble {
    var image: UIImage!
    var author: String!
    var title: String!
    
    init(image: UIImage!, title: String!, author: String!) {
        self.image = image
        self.title = title
        self.author = author
    }
}
