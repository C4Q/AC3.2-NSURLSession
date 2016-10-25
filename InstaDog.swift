//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Eashir Arafat on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
/*
{
    dog_id: "001",
    name: "Men's Wear Dog",
    instagram: "https://www.instagram.com/mensweardog/",
    imageName: "mens_wear_dog.jpg",
    stats: {
        followers: "283091",
        following: "269",
        posts: "518"
    }
}
 */
struct InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    let imageName: String
    let followers: Int
    let following: Int
    let posts: Int
    
    init(name: String, id: Int, instagramURL: URL, imageName: String, followers: Int, following: Int, posts: Int) {
        self.name = name
        self.dogID = id
        self.instagramURL = instagramURL
        self.imageName = imageName
        self.followers = followers
        self.following = following
        self.posts = posts
        
    }
    
    public var description: String {
        return "Nice to me you, I'm \(self.name)"
    }
}
