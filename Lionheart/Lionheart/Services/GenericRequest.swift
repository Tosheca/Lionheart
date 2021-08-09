//
//  GenericRequest.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

class GenericRequest {
    
    // Generalised function to retrieve response from request in the form of Data
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
