//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Tom Seymour on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

struct InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    let posts: String
    let followers: String
    let following: String
    let imageName: String
    
    init(name: String, id: Int, instagramURL: URL, posts: String, followers: String, following: String, imageName: String) {
        self.name = name
        self.dogID = id
        self.instagramURL = instagramURL
        self.posts = posts
        self.followers = followers
        self.following = following
        self.imageName = imageName
    }
    
    public var description: String {
        return "Nice to me you, I'm \(self.name)"
    }
}
