//
//  FlickrResponse.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

// Response based on Flickr API
// each "item" is an image
struct FlickrResponse: Codable {
    let items: [FlickrImageResponse]?
}
