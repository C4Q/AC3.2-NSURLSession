//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Marcel Chaucer on 10/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

struct InstaDog {
    
    let name: String
    let dogID: Int
    let instagramURL: URL
    let imageName: String
    let followers: Int
    let following: Int
    let numberOfPosts: Int
    
    init(name: String, dogID: Int, instagramURL: URL, imageName: String, followers: Int, following: Int, numberOfPosts: Int) {
        self.name = name
        self.dogID = dogID
        self.instagramURL = instagramURL
        self.imageName = imageName
        self.followers = followers
        self.following = following
        self.numberOfPosts = numberOfPosts
    }

    func formattedStats() -> String {
       return "Posts: \(numberOfPosts)   Followers: \(followers)   Following:\(following)"
    }
    
    func profileImage() -> UIImage? {
        
        return  UIImage(named: imageName)
}

}
