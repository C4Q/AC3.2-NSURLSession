//
//  InstaDogFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Victor Zhong on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

/// Used to create `[Instadog]`
class InstaDogFactory {
	
	static let manager: InstaDogFactory = InstaDogFactory()
	private init() {}
	
	
	/// Attempts to make `[InstaDog]` from the `Data` contained in a local file
	/// - parameter filename: The name of the file containing json-formatted data, including its extension in the name
	/// - returns: An array of `InstaDog` if the file is loDoged and has properly formatted data. `nil` otherwise.
	class func makeInstaDogs(fileName: String) -> [InstaDog]? {
		
		// Everything from viewDidLoad in InstaDogTableViewController has just been moved here
		guard let instaDogsURL: URL = InstaDogFactory.manager.getResourceURL(from: fileName),
			let instaDogData: Data = InstaDogFactory.manager.getData(from: instaDogsURL),
			let instaDogsAll: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: instaDogData) else {
				return nil
		}
		
		return instaDogsAll
	}
	
	
	/// Gets the `URL` for a local file
	fileprivate func getResourceURL(from fileName: String) -> URL? {
		
		guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
			return nil
		}
		
		let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
		let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
		
		let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
		
		return fileURL
	}
	
	/// Gets the `Data` from the local file loDoged at a specified `URL`
	fileprivate func getData(from url: URL) -> Data? {
		
		let fileData: Data? = try? Data(contentsOf: url)
		return fileData
	}
	
	
	// MARK: - Data Parsing
	/// Creates `[InstaDog]` from valid `Data`
	internal func getInstaDogs(from jsonData: Data) -> [InstaDog]? {
		
		do {
			let instaDogJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
			
			// Cast from Any and check for the "Dogs" key
			guard let instaDogJSONCasted: [String : AnyObject] = instaDogJSONData as? [String : AnyObject],
				let instaDogArray: [AnyObject] = instaDogJSONCasted["dogs"] as? [AnyObject] else {
					return nil
			}
			
			/*
			let name: String
			let dogID: Int
			let instagramURL: URL
			let imageName: URL
			let followers: Int
			let following: Int
			let posts: Int
			*/
			
			var instaDogs: [InstaDog] = []
			instaDogArray.forEach({ instaDogObject in
				guard let instaDogName: String = instaDogObject["name"] as? String,
					let instaDogIDString: String = instaDogObject["dog_id"] as? String,
					let instaDogInstagramURLString: String = instaDogObject["instagram"] as? String,
					let instaDogImageNameURLString: String = instaDogObject["imageName"] as? String,
					let instaDogStats: [String:Any] = instaDogObject["stats"] as? [String:Any],
					let instaDogFollowers: Int = instaDogStats["followers"] as? Int,
					let instaDogFollowing: Int = instaDogStats["following"] as? Int,
					let instaDogPosts: Int = instaDogStats["posts"] as? Int,
					// Some of these values need further casting
					let instaDogID: Int = Int(instaDogIDString),
					let instaDogInstagramURL: URL = URL(string: instaDogInstagramURLString),
					let instaDogImageNameURL: URL = URL(string: instaDogInstagramURLString+instaDogImageNameURLString)
					else {
						return
				}
				
				// append to our temp array
				instaDogs.append(InstaDog(name: instaDogName, id: instaDogID, instagramURL: instaDogInstagramURL, imageName: instaDogImageNameURL, followers: instaDogFollowers, following: instaDogFollowing, posts: instaDogPosts))
			})
			
			return instaDogs
		}
		catch let error as NSError {
			print("Error occurred while parsing data: \(error.localizedDescription)")
		}
		return  nil
	}
	
}
