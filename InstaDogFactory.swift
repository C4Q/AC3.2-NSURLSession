//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Marty Avedon on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class InstaDogFactory {
    
    static let manager: InstaDogFactory = InstaDogFactory() 
    private init() {} //no way to initialize this outside
    
    //I realize that I was asked to make these functions with different names, but comparing them to the functions with the corresponding signatures in catFactory, it seems like some kind of mix-up.
    
    internal func makeInstaDogs(from jsonData: Data) -> [InstaDog]? {
        guard let instaDogsURL: URL = InstaDogFactory.manager.getResourceURL(from: fileName),
            let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogsURL),
            let instaDogsAll: [InstaCat] = InstaDogFactory.manager.getInstaDogs(from: instaDogData) else {
                return nil
        }
        return [InstaDog]
    }
    
    private func getResourceURL(from fileName: String) -> URL? {
        
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        
        return fileURL
    }
    
    /// Gets the `Data` from the local file located at a specified `URL`
    private func getData(from url: URL) -> Data? {
        
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
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
                    print("I'm super before")
                    callback(allTheDogs)
                }
                }.resume()
            print("I'm super after")
        }
    }
}

