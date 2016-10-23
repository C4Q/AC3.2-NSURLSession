//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Marty Avedon on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

struct InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    
    init(name: String, id: Int, instagramURL: URL) {
        self.name = name
        self.dogID = id
        self.instagramURL = instagramURL
    }
    
    public var description: String {
        return "Boof, I'm \(self.name)"
    }
}
