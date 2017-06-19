//
//  File.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 6/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class InstaCatParser {
    init(){}
    
    func parseCats(from file: String) -> [InstaCat]? {
        guard let resourceURL = self.getResourceURL(from: file),
            let resourceData = self.getData(from: resourceURL),
            let resourceCats = self.parseInstaCats(from: resourceData) else {
                return nil
        }
        
        return resourceCats
    }
    
    // get an URL from String
    func getResourceURL(from fileName: String) -> URL? {
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        
        return fileURL
    }
    
    // get Data from file located at URL
    func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    // parse Data into InstaCats
    func parseInstaCats(from data: Data) -> [InstaCat]? {
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
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
    
}
