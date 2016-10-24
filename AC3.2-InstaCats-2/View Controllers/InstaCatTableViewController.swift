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
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogJSONFileName: String = "InstaDogs.json"
    internal var instaDogs: [InstaDog] = []
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    @IBOutlet weak var dogImage: UIImageView!
    
    let newDogFactory = InstaDogFactory.self
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.getInstaCats(apiEndpoint: instaCatEndpoint) { (returnedInstaCats: [InstaCat]?) in
            if let unwrappedReturnedInstaCats = returnedInstaCats {
                self.instaCats = unwrappedReturnedInstaCats
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }

        
        newDogFactory.InstaDogFactory.makeInstaDogs(apiEndpoint: instaDogEndpoint) { (returnedInstaDogs: [InstaDog]?) in
            if let unwrappedReturnedInstaDogs = returnedInstaDogs {
                self.instaDogs = unwrappedReturnedInstaDogs
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
    
    
    
    //for the api request
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
                    print(validData) // not of much use other than to tell us that data does exist
                    
                    if let allTheCats: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: validData) {
                        //to update the UI with data when view loads (otherwise you'll have to manually scroll to get the data
                        print(allTheCats)
                        callback(allTheCats)
                        
                    }
                }
                
            }.resume()
            
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.instaCats.count
        }
        else {
            return self.instaDogs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        let catCell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
        
            catCell.textLabel?.text = self.instaCats[indexPath.row].name
            catCell.detailTextLabel?.text = self.instaCats[indexPath.row].description
            
            return catCell
        }
        else {
            let dogCell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
            
            dogCell.textLabel?.text = self.instaDogs[indexPath.row].name
            dogCell.detailTextLabel?.text = "Posts: " + self.instaDogs[indexPath.row].numberOfPosts + " Following: " + self.instaDogs[indexPath.row].following + " Followers: " + self.instaDogs[indexPath.row].followers
            dogCell.imageView?.image = UIImage(named: self.instaDogs[indexPath.row].imageName)
            
            
            return dogCell
        }
    }

}
