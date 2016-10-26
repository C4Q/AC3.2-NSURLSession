//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Annie Tung on 10/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

struct InstaDog {
    let dogID: Int
    let name: String
    let instagramURL: URL
    let imageName: String
    let followers: String
    let following: String
    let posts: String
    
    init(name: String, id: Int, instagramURL: URL, imageName: String, followers: String, following: String, posts: String){
        self.dogID = id
        self.name = name
        self.instagramURL = instagramURL
        self.imageName = imageName
        self.followers = followers
        self.following = following
        self.posts = posts
    }
    
    public var description: String {
        return "Posts: \(self.posts) Followers: \(self.followers) Following: \(self.following)"
    }
    
    func dogthumbnail() -> UIImage? {
        return UIImage(named: self.imageName)
    }
}
