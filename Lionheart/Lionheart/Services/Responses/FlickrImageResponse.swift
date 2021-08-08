//
//  FlickrImageResponse.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

struct FlickrImageResponse: Codable {
    let title: String?
    let author: String?
    let media: FlickrImageMediaResponse?
}

struct FlickrImageMediaResponse: Codable {
    var m: String? {
        didSet {
            self.m = self.m?.replacingOccurrences(of: "_m.", with: "_c.")
        }
    }
}
