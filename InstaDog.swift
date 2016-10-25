//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Erica Y Stevens on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

struct InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    let stats: [String:String]
    let followers: String
    let following: String
    let posts: String
    let imageName: String
    
    init?(name: String, id: Int, instagramURL: URL, stats: [String:String], followers: String, following: String, posts: String, imageName: String) {
        self.name = name
        self.dogID = id
        self.instagramURL = instagramURL
        self.stats = stats
        self.imageName = imageName
        if let followers = stats["followers"], let following = stats["following"], let posts = stats["posts"] {
            self.followers = followers
            self.following = following
            self.posts = posts
        }
        else {
            print("Initializer Failed")
            return nil
        }
    }
    
    public var description: String {
        return "Nice to me you, I'm \(self.name)"
    }

}
