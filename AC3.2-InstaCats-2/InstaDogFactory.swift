//
//  InstaCatFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit


/// Used to create `[InstaCat]`
class InstaDogFactory {
    
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    

    static let manager: InstaDogFactory = InstaDogFactory()
    init() {}
    
    
    /// Attempts to make `[InstaCat]` from the `Data` contained in a local file
    /// - parameter filename: The name of the file containing json-formatted data, including its extension in the name
    /// - returns: An array of `InstaCat` if the file is located and has properly formatted data. `nil` otherwise.
    class func makeInstaDogs(fileName: String) -> [InstaDog]? {
        
        // Everything from viewDidLoad in InstaCatTableViewController has just been moved here
        guard let instaDogsURL: URL = InstaDogFactory.manager.getResourceURL(from: fileName),
            let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogsURL),
            let instaDogsAll: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: instaDogData) else {
                return nil
        }
        
        return instaDogsAll
    }
    
    
    /// Gets the `URL` for a local file
    fileprivate func getResourceURL(from fileName: String) -> URL? {
        
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        
        return fileURL
    }
    
    /// Gets the `Data` from the local file located at a specified `URL`
    fileprivate func getData(from url: URL) -> Data? {
        
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    
    // MARK: - Data Parsing
    /// Creates `[InstaCat]` from valid `Data`
    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
        
        do {
            let instaDogJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Cast from Any and check for the "cats" key
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
                    let instaDogFollowers: Int = instaDogObject["followers"] as? Int,
                    let instaDogFollowing: Int = instaDogObject["following"] as? Int,
                    let instaDogPosts: Int = instaDogObject["posts"] as? Int,
                    // Some of these values need further casting
                    let instaDogID: Int = Int(instaDogIDString),
                    let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString)
                
                    else {
                        return
                }
                
        
                
                // append to our temp array
                instaDogs.append(InstaDog(name: instaDogName, id: instaDogID, instagramURL: instaDogInstagramURL, imageName: instaDogImageName, followers: instaDogFollowers, following: instaDogFollowing, posts: instaDogPosts))
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
