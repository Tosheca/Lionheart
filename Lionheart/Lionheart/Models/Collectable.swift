//
//  Collectable.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 1.08.21.
//

import Foundation
import UIKit

// A Collectable represents an image
class Collectable {
    var image: UIImage!
    var author: String!
    var title: String!
    
    init(image: UIImage!, title: String!, author: String!) {
        self.image = image
        self.title = title
        self.author = author
    }
}
