//
//  CollectablesDataFetcher.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation
import UIKit

// This class is used to fetch Collectables and process the data from the responses to the Collectable objects
class CollectablesDataFetcher {
    
    // MARK: Collectables processing
    static func fetchCollectables(completion: @escaping([Collectable]) -> Void) {
        var fetchedCollectables = [Collectable]()
        
        let dispatchGroup = DispatchGroup() // Used to ensure all images are downloaded before continuing
        
        ImagesServiceRepo.fetchFlickrImages(completion: { flickrResponse in
            for item in flickrResponse.items! {
                dispatchGroup.enter()
                let imageURL = CollectablesDataFetcher.formatImageURL(imageURLString: item.media?.m)
                let author = CollectablesDataFetcher.formatAuthor(author: item.author)
                CollectablesDataFetcher.downloadImage(from: imageURL, completion: { downloadedImage in
                    fetchedCollectables.append(Collectable(image: downloadedImage, title: item.title, author: author))
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completion(fetchedCollectables)
            })
        })
    }
    
    // MARK: Image downloading
    static func downloadImage(from url: URL, completion: @escaping(_ image: UIImage?) -> Void) {
        GenericRequest.getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
    }
    
    //MARK: Response Formatting
    // Formats the Flickr response to a readable representation
    static func formatAuthor(author: String?) -> String? {
        var formattedAuthor = author
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "nobody@flickr.com", with: "") ?? ""
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "(\"", with: "")
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "\")", with: "")
        
        return formattedAuthor
    }
    
    // Formats the image download url. Flickr response uses "m" symbol in their url to represent image size. "m" is replaced
    // with "c" for higher resolution
    // See https://www.flickr.com/services/api/misc.urls.html
    static func formatImageURL(imageURLString: String?) -> URL {
        var formattedImageString = imageURLString
        formattedImageString = formattedImageString?.replacingOccurrences(of: "_m.", with: "_c.")
        
        return URL(string: formattedImageString!)!
    }
}
