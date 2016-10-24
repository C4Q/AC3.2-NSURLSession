//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
	internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
	internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
	internal let instaCatJSONFileName: String = "InstaCats.json"
	internal var instaCats: [InstaCat] = []
	internal var instaDogs: [InstaDog] = []
	internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
	internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
	
	func getInstaCats(apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
		if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
			
			// 1. URLSession/Configuration
			let session = URLSession(configuration: URLSessionConfiguration.default)
			
			// 2. dataTaskWithURL
			session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
				
				// 3. check for errors right away
				if error != nil {
					print("Error encountered!: \(error!)")
				}
				
				// 4. printing out the data
				if let validData: Data = data {
					print(validData)
					
					// 5. reuse our code to make some cats from Data
					
					
					// 6. if we're able to get non-nil [InstaCat], set our variable and reload the data
					if let instaCats: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: validData) {
						//						self.instaCats = instaCats
						// update the UI by wrapping the UI-updating code inside of a DispatchQueue closure
						//						DispatchQueue.main.async {
						//							self.tableView.reloadData()
						//						}
						callback(instaCats)
						print("\n\n\n\n\nCallback resolves\n\n\n\n\n")
						
					}
				}
				}.resume()
			print("\n\n\n\n\nResume resolves\n\n\n\n\n")
		}
	}
	
	func getInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
		if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
			
			// 1. URLSession/Configuration
			let session = URLSession(configuration: URLSessionConfiguration.default)
			
			// 2. dataTaskWithURL
			session.dataTask(with: validInstaDogEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
				
				// 3. check for errors right away
				if error != nil {
					print("Error encountered!: \(error!)")
				}
				
				// 4. printing out the data
				if let validData: Data = data {
					print(validData)
					
					// 5. reuse our code to make some cats from Data
					
					
					// 6. if we're able to get non-nil [InstaCat], set our variable and reload the data
					if let instaDogs: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: validData) {
						callback(instaDogs)
						print("\n\n\n\n\nCallback resolves\n\n\n\n\n")
						
					}
				}
				}.resume()
			print("\n\n\n\n\nResume resolves\n\n\n\n\n")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//		if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
		//			self.instaCats = instaCatsAll
		//			self.getInstaCats(from: instaCatEndpoint)
		//		}
		
		//		self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
		//			if instaCats != nil {
		//				for cat in instaCats! {
		//					print(cat.description)
		//
		//					DispatchQueue.main.async {
		//						self.instaCats = instaCats!
		//						self.tableView.reloadData()
		//					}
		//				}
		//			}
		//		}
		
		
		self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
			if let returnedInstaCats = instaCats {
				self.instaCats = returnedInstaCats
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
		
		self.getInstaDogs(apiEndpoint: instaDogEndpoint) { (instaDogs: [InstaDog]?) in
			if let returnedInstaDogs = instaDogs {
				self.instaDogs = returnedInstaDogs
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return instaCats.count
		} else {
			print("\n\n Dogs count: \(instaDogs.count)\n\n")
			return instaDogs.count
		}
	}
	
	//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//		let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
	//
	//		cell.textLabel?.text = self.instaCats[indexPath.row].name
	//		cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
	//
	//		return cell
	//	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
			
			let currentCat = instaCats[indexPath.row]
			
			cell.textLabel?.text = currentCat.name
			cell.detailTextLabel?.text = currentCat.description
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
			
			let currentDog = instaDogs[indexPath.row]
			
			cell.textLabel?.text = currentDog.name
			cell.detailTextLabel?.text = String(currentDog.description)
//			cell.imageView?.image = 
			
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "InstaCats"
		}
		else {
			return "InstaDogs"
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// UIApplication.shared.openURL(URL(string: String(describing: instaCats[indexPath.row].instagramURL))!)
		UIApplication.shared.open(instaCats[indexPath.row].instagramURL)
	}
}
