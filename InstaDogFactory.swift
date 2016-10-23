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
    
    class func makeInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
    
    }
    
    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
        
        return [InstaDog]()
    }
}
