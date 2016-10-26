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
//    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal var instaDogs: [InstaDog] = []
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //From local JSON
        //        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
        //            self.instaCats = instaCatsAll
        //        }
        
        self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
            if instaCats != nil {
                for cat in instaCats! {
                    print(cat.description)
                    
                    DispatchQueue.main.async {
                        self.instaCats = instaCats!
                        self.tableView.reloadData()
                    }
                }
            }
        }
        self.getInstaDogs(apiEndpoint: instaDogEndpoint) { (instaDogs: [InstaDog]?) in
            if instaDogs != nil {
                for dog in instaDogs! {
                    print(dog.description)
                    
                    DispatchQueue.main.async {
                        self.instaDogs = instaDogs!
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                    
                    // 6. if we're able to get non-nil [InstaCat], set our variable and reload the data
                    if let instaCats: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: validData) {
                        callback(instaCats)
                    }
                }
            }.resume()
        }
    }
    
    func getInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
        if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            session.dataTask(with: validInstaDogEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                if let validData: Data = data {
                    print(validData)
                    if let instaDogs: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: validData) {
                        callback(instaDogs)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
            
            cell.textLabel?.text = self.instaCats[indexPath.row].name
            cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
            
            cell.textLabel?.text = self.instaDogs[indexPath.row].name
            cell.detailTextLabel?.text = self.instaDogs[indexPath.row].description
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "InstaMeows"
        }
        else {
            return "InstaWoofs"
        }
    }
    
}
