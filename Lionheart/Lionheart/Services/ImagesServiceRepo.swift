//
//  ImagesServiceRepo.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation

class ImagesServiceRepo {
    static func fetchFlickrImages(completion: @escaping(FlickrResponse) -> Void) {
        let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?tags=animals&tagmode=all&format=json&nojsoncallback=1"
        
        GenericRequest.getData(from: URL(string :flickrURL)!, completion: { (data, response, error) in
            do {
                let flickrResponse = try JSONDecoder().decode(FlickrResponse.self, from: data!)
                completion(flickrResponse)
                
            } catch {
                print(error)
            }
        })
    }
}
