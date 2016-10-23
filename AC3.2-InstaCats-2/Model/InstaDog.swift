//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Ana Ma on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

/*{
    dog_id: "001",
    name: "Men's Wear Dog",
    instagram: "https://www.instagram.com/mensweardog/",
    imageName: "mens_wear_dog.jpg",
    stats: {
        followers: "283091",
        following: "269",
        posts: "518"
    }
},
*/

struct InstaDog {
    let name: String
    let id: String
    let instagram: String
    let imageName: String
    //let stats: [String: String]
    let followers: String
    let following: String
    let posts: String
    
    init (name: String, id: String, instagram: String, imageName: String, followers: String, following: String, posts: String){
        self.name = name
        self.id = id
        self.instagram = instagram
        self.imageName = imageName
        //self.stats = stats
        self.followers = followers
        self.following = following
        self.posts = posts
    }
}
