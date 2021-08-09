//
//  FlickrImageResponse.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

// Response based on Flickr API
// each image response
struct FlickrImageResponse: Codable {
    let title: String?
    let author: String?
    let media: FlickrImageMediaResponse?
}

// Response based on Flickr API
// Flickr uses specific structure for media urls
struct FlickrImageMediaResponse: Codable {
    let m: String?
}
