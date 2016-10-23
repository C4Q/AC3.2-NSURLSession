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
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogJSONFileName: String = "InstaDogs.json"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    internal var instaCats: [InstaCat] = []
    internal var instaDogs: [InstaDog] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInstaCats(from: instaCatEndpoint) { (cats: [InstaCat]?) in
            if let goodCats = cats {
                self.instaCats = goodCats
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        getInstaDogs(from: instaDogEndpoint) { (dogs: [InstaDog]?) in
            if let goodDogs = dogs {
                self.instaDogs = goodDogs
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
            self.instaCats = instaCatsAll
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instaCats.count + self.instaDogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.instaCats[indexPath.row].name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
        
        cell.textLabel?.text = self.instaDogs[indexPath.row].name
        cell.detailTextLabel?.text = self.instaDogs[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }
    
    // MARK: - Getting the URL
    func getInstaCats(from apiEndpoint: String, callback:@escaping ([InstaCat]?)->()) {
        
        if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) { // if it is an url it will run
        
            // 1. URLSession/Configuration (get info from URL)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // 2. dataTaskWithURL (when it finishes add it to the array, the closure is being sent to dataTask on the url session)
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
                        if let allTheCats = InstaCatFactory.manager.getInstaCats(from: validData) {
                            print("This is the callback for instacats")
                        callback(allTheCats)
                    }
                }
            }.resume() // starts, always follows with dataTask
            print("resume dataTask")
        }
    }
    
    func getInstaDogs(from apiEndpoint: String, callback: @escaping ([InstaDog]?) -> ()) {
        if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: validInstaDogEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                if let validData: Data = data {
                    print(validData)

                if let allTheDogs = InstaDogFactory.manager.getInstaDogs(from: validData) {
                    print("This is the callback for instadogs")
                    callback(allTheDogs)
                    }
                }
            }.resume()
        print("resume dataTask for instadogs")
        }
    }
}



