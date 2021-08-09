//
//  ImagesServiceRepo.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

// This class holds functions for retrieving image data.
class ImagesServiceRepo {
    
    // MARK: Flickr Images Fetch
    static func fetchFlickrImages(completion: @escaping(FlickrResponse) -> Void) {
        // Official flickr API request url
        // NOTE: "nojsoncallback=1" is a must to get a valid JSON response
        let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?tags=animals&tagmode=all&format=json&nojsoncallback=1"
        
        GenericRequest.getData(from: URL(string :flickrURL)!, completion: { (data, response, error) in
            do {
                // Decoding JSON to expected response type
                let flickrResponse = try JSONDecoder().decode(FlickrResponse.self, from: data!)
                completion(flickrResponse)
                
            } catch {
                print(error)
            }
        })
    }
}
