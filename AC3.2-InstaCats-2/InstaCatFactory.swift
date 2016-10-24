//
//  InstaCatFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

//hey, you know, if this wasn't a darn singleton we could create two instances, one for cats and one for dogs
//on the other hand, we could create a factory protocol that two different classes (cat and dog factories) conform to, and create some extensions to define the methods within, so we don't have to do so much of a copy-paste job when it comes time to make dogs
//or...we could run the dog data through the catFactory. Which we are told very much not to do in the directions.


/// Used to create `[InstaCat]`
class InstaCatFactory {

    static let manager: InstaCatFactory = InstaCatFactory() //makes this a singleton -- only one instance of this can ever exist because of the static let
    private init() {}
    
    
    /// Attempts to make `[InstaCat]` from the `Data` contained in a local file
    /// - parameter filename: The name of the file containing json-formatted data, including its extension in the name
    /// - returns: An array of `InstaCat` if the file is located and has properly formatted data. `nil` otherwise.
    class func makeInstaCats(fileName: String) -> [InstaCat]? {
        
        guard let instaCatsURL: URL = InstaCatFactory.manager.getResourceURL(from: fileName),
            let instaCatData: Data = InstaCatFactory.manager.getData(from: instaCatsURL),
            let instaCatsAll: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: instaCatData) else {
                return nil
        }
        
        return instaCatsAll
    }
    
    
    /// Gets the `URL` for a file
    private func getResourceURL(from fileName: String) -> URL? {
        
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        } //breaks up file's name into pieces
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound) //everything before the first period is the actual name of the file
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound) //everything after the first period is the file's extension or format
        
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent) //Swift needs the name to be broken up because this method takes the two parts as two separate parameters
        
        return fileURL
    }
    
    /// Gets the `Data` from the LOCAL file located at a specified `URL`
    fileprivate func getData(from url: URL) -> Data? {
        
        let fileData: Data? = try? Data(contentsOf: url) //try to get the data and give us nil if we can't
        return fileData
    }
    
    
    // MARK: - Data Parsing
    /// Creates `[InstaCat]` from valid LOCAL `Data`
    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Cast from Any and check for the "cats" key
            guard let instaCatJSONCasted: [String : AnyObject] = instaCatJSONData as? [String : AnyObject],
                let instaCatArray: [AnyObject] = instaCatJSONCasted["cats"] as? [AnyObject] else {
                    return nil
            }
            
            var instaCats: [InstaCat] = []
            instaCatArray.forEach({ instaCatObject in
                guard let instaCatName: String = instaCatObject["name"] as? String,
                    let instaCatIDString: String = instaCatObject["cat_id"] as? String,
                    let instaCatInstagramURLString: String = instaCatObject["instagram"] as? String,
                    
                    // Some of these values need further casting
                    let instaCatID: Int = Int(instaCatIDString),
                    let instaCatInstagramURL: URL = URL(string: instaCatInstagramURLString) else {
                        return
                }
                
                // append to our temp array
                instaCats.append(InstaCat(name: instaCatName, id: instaCatID, instagramURL: instaCatInstagramURL))
            })
            
            return instaCats
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }
    
//    /// Creates `[InstaCat]` from valid REMOTE `Data`
//    func getInstaCats(apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
//        if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
//            
//            // 1. URLSession/Configuration
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            
//            // 2. dataTaskWithURL
//            session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
//                
//                // 3. check for errors right away
//                if error != nil {
//                    print("Error encountered!: \(error!)")
//                }
//                
//                // 4. printing out the data
//                if let validData: Data = data {
//                    print(validData)
//                    
//                    // 5. reuse our code to make some cats from Data
//                    let allTheCats: [InstaCat]? = InstaCatFactory.manager.getInstaCats(from: validData)
//                    print("I'm super before")
//                    callback(allTheCats)
//                }
//            }.resume()
//            print("I'm super after")
//        }
//    }
}
