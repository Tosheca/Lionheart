//
//  FlickrResponse.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrImageResponse]?
}
