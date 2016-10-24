//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Harichandan Singh on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaDogFactory {
    
    static let manager: InstaDogFactory = InstaDogFactory()
    private init() {}
    
    class func makeInstaDogs(fileName: String) -> [InstaDog]? {
        guard let instaDogURL: URL = InstaDogFactory.manager.getResourceURL(from: fileName),
            let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogURL),
            let instaDogsAll:[InstaDog] = InstaDogFactory.manager.getInstaDogs(from: instaDogData) else {
                return nil
        }
        return instaDogsAll
    }
    
    fileprivate func getResourceURL(from fileName: String) -> URL? {
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtensionComponent: String = fileName.substring(from: dotRange.upperBound)
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtensionComponent)
        
        return fileURL
    }
    
    fileprivate func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        
        return fileData
    }
    
    //MARK: - Data Parsing
    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
        
        do {
            let instaDogJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            guard let instaDogJSONCasted: [String : AnyObject] = instaDogJSONData as? [String : AnyObject],
                let instaDogArray: [AnyObject] = instaDogJSONCasted["dogs"] as? [AnyObject] else {
                    return nil
            }
            
            var instaDogs: [InstaDog] = []
            instaDogArray.forEach({ instaDogObject in
                guard let instaDogName: String = instaDogObject["name"] as? String,
                    let instaDogIDString: String = instaDogObject["dog_id"] as? String,
                    let instaDogInstagramURLString: String = instaDogObject["instagram"] as? String,
                    let instaDogImageName: String = instaDogObject["imageName"] as? String,
                    let instaDogStats: [String: String] = instaDogObject["stats"] as? [String: String],
                    let instaDogFollowersString: String = instaDogStats["followers"],
                    let instaDogFollowingString: String = instaDogStats["following"],
                    let instaDogPostsString: String = instaDogStats["posts"],
                    
                    // Some of these values need further casting
                    let instaDogID: Int = Int(instaDogIDString),
                    let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString) else {
                        return
                }
                let instaDogFollowers: Int = Int(instaDogFollowersString)!
                let instaDogFollowing: Int = Int(instaDogFollowingString)!
                let instaDogPosts: Int = Int(instaDogPostsString)!
                
                // append to our temp array
                instaDogs.append(InstaDog(name: instaDogName, dogID: instaDogID, instagramURL: instaDogInstagramURL, imageName: instaDogImageName, followers: instaDogFollowers, following: instaDogFollowing, numberOfPosts: instaDogPosts))
            })
            
            return instaDogs
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }
    
    func getInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
        if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
            
            // 1. URLSession/Configuration
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // 2. dataTaskWithURL
            session.dataTask(with: validInstaDogEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                
                // 3. check for errors right away
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                
                // 4. printing out the data
                if let validData: Data = data {
                    print(validData)
                    
                    // 5. reuse our code to make some cats from Data
                    let allTheDogs: [InstaDog]? = InstaDogFactory.manager.getInstaDogs(from: validData)
                    
                    callback(allTheDogs)
                }
                }.resume()
        }
    }
    
}
