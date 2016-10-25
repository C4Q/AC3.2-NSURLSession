//
//  InstaCatFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit


/// Used to create `[InstaCat]`
class InstaCatFactory {

    static let manager: InstaCatFactory = InstaCatFactory()
    private init() {}
    
    
    // MARK: - Data Parsing
    /// Creates `[InstaCat]` from valid `Data`
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
    
    func getInstaCatsTwo(from apiEndpoint: String, callback:@escaping ([InstaCat]?)->()) {
        if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                if let validData: Data = data {
                    if let allTheCats = InstaCatFactory.manager.getInstaCats(from: validData) {
                        callback(allTheCats)
                        if error != nil {
                            print("Error encountered!: \(error!)")
                        }
                    }
                }
                }.resume()
        }
    }

    
}
