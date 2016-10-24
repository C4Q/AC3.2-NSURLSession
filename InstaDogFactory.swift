//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Annie Tung on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaDogFactory {
    static let manager: InstaDogFactory = InstaDogFactory()
    private init() {}
    
    class func makeInstaDogs(fileName: String) -> [InstaDog]? {
        
        guard let instaDogsURL: URL = InstaDogFactory.manager.getResouceURL(from: fileName),
            let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogsURL),
            let instaDogsAll: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: instaDogData) else { return nil }
        return instaDogsAll
    }
    
    private func getResouceURL(from fileName: String) -> URL? {
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else { return nil }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtensionComponent: String = fileName.substring(from: dotRange.upperBound)
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtensionComponent)
        return fileURL
    }
    
    private func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
        
        do {
            let instaDogJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let instaDogJSONCasted: [String : AnyObject] = instaDogJSONData as? [String: AnyObject],
                let instaDogArray: [AnyObject] = instaDogJSONCasted["dogs"] as? [AnyObject] else { return nil }
            
            var instaDogs: [InstaDog] = []
            instaDogArray.forEach({ instaDogObject in
                guard let instaDogName: String =
                        instaDogObject["name"] as? String,
                    let instaDogIDString: String =
                        instaDogObject["dog_id"] as? String,
                    let instaDogInstagramURLString: String =
                        instaDogObject["instagram"] as? String,
                    let instaDogFollowers: String =
                        instaDogObject["follower"] as? String,
                    let instaDogFollowing: String =
                        instaDogObject["following"] as? String,
                    let instaDogPosts: String =
                        instaDogObject["post"] as? String,
                    
                    let instaDogID: Int = Int(instaDogIDString),
                    let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString) else { return }
                
                instaDogs.append(InstaDog(name: instaDogName, id: instaDogID, instagramURL: instaDogInstagramURL, followers: instaDogFollowers, following: instaDogFollowing, posts: instaDogPosts))
            })
            return instaDogs
        }
        catch let error as NSError {
            print("Error occurred while parsing Data:\(error.localizedDescription)")
        }
        return nil
    }
}













