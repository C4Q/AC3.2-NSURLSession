//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Madushani Lekam Wasam Liyanage on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation



class InstaDogFactory {

//    class func makeInstaCats(fileName: String) -> [InstaCat]? {
//        
//        // Everything from viewDidLoad in InstaCatTableViewController has just been moved here
//        guard let instaCatsURL: URL = InstaCatFactory.manager.getResourceURL(from: fileName),
//            let instaCatData: Data = InstaCatFactory.manager.getData(from: instaCatsURL),
//            let instaCatsAll: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: instaCatData) else {
//                return nil
//        }
//        
//        return instaCatsAll
//    }
//    //
//    //
//    //    /// Gets the `URL` for a local file
//    fileprivate func getResourceURL(from fileName: String) -> URL? {
//        
//        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
//            return nil
//        }
//        
//        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
//        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
//        
//        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
//        
//        return fileURL
//    }
//    
//    /// Gets the `Data` from the local file located at a specified `URL`
//    fileprivate func getData(from url: URL) -> Data? {
//        
//        let fileData: Data? = try? Data(contentsOf: url)
//        return fileData
//    }
//    //
//    //
//    // MARK: - Data Parsing
//    /// Creates `[InstaCat]` from valid `Data`
//    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
//        
//        do {
//            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
//            
//            // Cast from Any and check for the "cats" key
//            guard let instaCatJSONCasted: [String : AnyObject] = instaCatJSONData as? [String : AnyObject],
//                let instaCatArray: [AnyObject] = instaCatJSONCasted["cats"] as? [AnyObject] else {
//                    return nil
//            }
//            
//            var instaCats: [InstaCat] = []
//            instaCatArray.forEach({ instaCatObject in
//                guard let instaCatName: String = instaCatObject["name"] as? String,
//                    let instaCatIDString: String = instaCatObject["cat_id"] as? String,
//                    let instaCatInstagramURLString: String = instaCatObject["instagram"] as? String,
//                    
//                    // Some of these values need further casting
//                    let instaCatID: Int = Int(instaCatIDString),
//                    let instaCatInstagramURL: URL = URL(string: instaCatInstagramURLString) else {
//                        return
//                }
//                
//                // append to our temp array
//                instaCats.append(InstaCat(name: instaCatName, id: instaCatID, instagramURL: instaCatInstagramURL))
//            })
//            
//            return instaCats
//        }
//        catch let error as NSError {
//            print("Error occurred while parsing data: \(error.localizedDescription)")
//        }
//        
//        return  nil
//    }
//

    class InstaDogFactory {
        
        static let manager: InstaDogFactory = InstaDogFactory()
        private init() {}
        
        
        class func makeInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
            
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
                        print(validData) // not of much use other than to tell us that data does exist
                        
                        if let allTheDogs: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: validData) {
                            //to update the UI with data when view loads (otherwise you'll have to manually scroll to get the data
                            print(allTheDogs)
                            callback(allTheDogs)
                            
                        }
                    }
                    
                    }.resume()
                
            }
            
            
        }
        
            fileprivate func getResourceURL(from fileName: String) -> URL? {
        
                guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
                    return nil
                }
        
                let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
                let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
                let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
                
                return fileURL
            }

            fileprivate func getData(from url: URL) -> Data? {
        
                let fileData: Data? = try? Data(contentsOf: url)
                return fileData
            }
        
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
                        let instaDogImageNameString: String = instaDogObject["imageName"] as? String,
                        let instaDogStatsDict: [String : String] = instaDogObject["stats"] as? [String : String],
                        let instaDogFollowers: String = instaDogStatsDict["followers"],
                        let instaDogFollowing: String = instaDogStatsDict["following"],
                        let instaDogPosts: String = instaDogStatsDict["posts"],
                        
                        // Some of these values need further casting
                        let instaDogID: Int = Int(instaDogIDString),
                        let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString) else {
                            return
                    }
                    
                    instaDogs.append(InstaDog(name: instaDogName, dogId: instaDogID, instagramURL: instaDogInstagramURL, imageName: instaDogImageNameString, followers: instaDogFollowers, following: instaDogFollowing, numberOfPosts: instaDogPosts))
                })
                return instaDogs
            }
            catch let error as NSError {
                print("Error occurred while parsing data: \(error.localizedDescription)")
            }
            
            return  nil
        }
        
    }
    
    
    
    
    
    
    
    
    
}
