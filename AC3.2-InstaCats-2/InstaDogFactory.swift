//
//  File.swift
//  AC3.2-InstaCats-2
//
//  Created by Marcel Chaucer on 10/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

//Used to create [InstaDog]
 class InstaDogFactory {
    
    static let manager: InstaDogFactory = InstaDogFactory()
    private init() {}
    
    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
        
        do {
            let instaDogJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Cast from Any and check for the "dogs" key
            guard let instaDogJSONCasted: [String : AnyObject] = instaDogJSONData as? [String : AnyObject],
                let instaDogArray: [AnyObject] = instaDogJSONCasted["dogs"] as? [AnyObject] else {
                    return nil
            }
            
            var instaDogs: [InstaDog] = []
            instaDogArray.forEach({ instaDogObject in
                guard let instaDogName: String = instaDogObject["name"] as? String,
                    let instaDogIDString: String = instaDogObject["dog_id"] as? String,
                    let instaDogInstagramURLString: String = instaDogObject["instagram"] as? String,
                    let instaDogImage: String = instaDogObject["imageName"] as? String,
                    let instaStats = instaDogObject["stats"] as? [String:String],
                    let instaDogFollowers = instaStats["followers"] as String?,
                    let instaDogfollowing = instaStats["following"] as String?,
                    let instaDognumberOfPosts = instaStats["posts"] as String?,
                    
               
                    let instaDogID: Int = Int(instaDogIDString),
                    let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString),
                    
                    let instaDogFollowersNumber: Int = Int(instaDogFollowers),
                    let instaDogFollowingNumber = Int(instaDogfollowing),
                    let instaDogPostsNumber = Int(instaDognumberOfPosts)
                    else {
                        return
                }

                
                instaDogs.append(InstaDog(name: instaDogName, dogID: instaDogID, instagramURL:instaDogInstagramURL, imageName: instaDogImage, followers: instaDogFollowersNumber, following: instaDogFollowingNumber, numberOfPosts: instaDogPostsNumber))
            })
            
            return instaDogs
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }

    func makeInstaDogs(from apiEndpoint: String, callback:@escaping ([InstaDog]?)->()) {
        if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: validInstaDogEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                if let validData: Data = data {
                    if let allTheDogs = InstaDogFactory.manager.getInstaDogs(from:validData) {
                        callback(allTheDogs)
                        if error != nil {
                            print("Error encountered!: \(error!)")
                        }
                    }
                }
                }.resume()
        }
    }
}


