//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Harichandan Singh on 10/23/16.
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
    
    
    init (name: String, dogID: Int, instagramURL: URL, imageName: String, followers: Int, following: Int, numberOfPosts: Int){
        self.name = name
        self.dogID = dogID
        self.instagramURL = instagramURL
        self.imageName = imageName
        //self.stats = stats
        self.followers = followers
        self.following = following
        self.numberOfPosts = numberOfPosts
    }
    
        func formattedStats() -> String {
            let str = "Posts: \(self.numberOfPosts)   Followers: \(self.followers)   Following:\(self.following)"
            return str
        }
        
        func profileImage() -> UIImage? {
            return UIImage(named: self.imageName)
            
        }
}
