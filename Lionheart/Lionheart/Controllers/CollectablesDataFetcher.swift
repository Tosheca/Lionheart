//
//  CollectablesDataFetcher.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 8.08.21.
//

import Foundation
import UIKit

class CollectablesDataFetcher {
    static func fetchCollectables(completion: @escaping([Collectable]) -> Void) {
        var fetchedCollectables = [Collectable]()
        
        let dispatchGroup = DispatchGroup()
        
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
    
    static func downloadImage(from url: URL, completion: @escaping(_ image: UIImage?) -> Void) {
        GenericRequest.getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
    }
    
    static func formatAuthor(author: String?) -> String? {
        var formattedAuthor = author
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "nobody@flickr.com", with: "") ?? ""
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "(\"", with: "")
        formattedAuthor = formattedAuthor?.replacingOccurrences(of: "\")", with: "")
        
        return formattedAuthor
    }
    
    static func formatImageURL(imageURLString: String?) -> URL {
        var formattedImageString = imageURLString
        formattedImageString = formattedImageString?.replacingOccurrences(of: "_m.", with: "_c.")
        
        return URL(string: formattedImageString!)!
    }
}
