//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by C4Q on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation


class InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    let imageName: String
    let followers: String
    let following: String
    let posts: String
    
    init(name: String, id: Int, instagramURL: URL, imageName: String, followers: String, following: String, posts: String) {
        self.name = name
        self.dogID = id
        self.instagramURL = instagramURL
        self.imageName = imageName
        self.followers = followers
        self.following = following
        self.posts = posts
    }
    
    public var description: String {
        return "Posts: \(self.posts), Followers: \(self.followers), Following: \(self.following)"
    }
}
