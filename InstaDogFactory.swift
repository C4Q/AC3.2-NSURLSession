//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Erica Y Stevens on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaDogFactory {
    static let manager: InstaDogFactory = InstaDogFactory()
    private init() {}
    
    
    /// Attempts to make `[InstaDog]` from the `Data` contained in a local file
    /// - parameter filename: The name of the file containing json-formatted data, including its extension in the name
    /// - returns: An array of `InstaDog` if the file is located and has properly formatted data. `nil` otherwise.
    //makeInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void)
    

    class func makeInstaDogs(fileName: String) -> [InstaDog]? {
        
        // Everything from viewDidLoad in InstaCatTableViewController has just been moved here
        guard let instaDogURL: URL = InstaDogFactory.manager.getResourceURL(from: fileName),
            let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogURL),
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
    //getInstaDogs(from jsonData: Data) -> [InstaDog]?
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
                    let instaDogStatsDict: [String:String] = instaDogObject["stats"] as? [String:String],
                    let instaDogImageNameString: String = instaDogObject["imageName"] as? String,
                    // Some of these values need further casting
                    let instaDogID: Int = Int(instaDogIDString),
                    let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString) else {
                        print("CASTING FAILED")
                        return
                }
                guard let instaDogFollwersString: String = instaDogStatsDict["followers"],
                    let instaDogFollowingString: String = instaDogStatsDict["following"],
                    let instaDogPostsString: String = instaDogStatsDict["posts"] else {
                        print("Indexing into stats failed")
                        return
                }
                
                // append to our temp array
                //APP MAY CRASH BC OF FORCE UNWRAPPING
                instaDogs.append(InstaDog(name: instaDogName, id: instaDogID, instagramURL: instaDogInstagramURL, stats: instaDogStatsDict, followers: instaDogFollwersString, following: instaDogFollowingString, posts: instaDogPostsString,imageName: instaDogImageNameString)!)
            })
            
            return instaDogs
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }
    

}
