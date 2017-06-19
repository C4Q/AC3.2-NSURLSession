//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 6/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

struct InstaDog {
    let name: String
    let dogID: Int
    let instagramURL: URL
    let imageName: String
    let followers: Int
    let following: Int
    let numberOfPosts: Int
    
    internal func formattedStats() -> String {
        return "Posts: \(numberOfPosts)   Followers: \(followers)   Following:\(following)"
    }
    
    internal func profileImage() -> UIImage? {
        return UIImage(named: imageName)
    }
}
