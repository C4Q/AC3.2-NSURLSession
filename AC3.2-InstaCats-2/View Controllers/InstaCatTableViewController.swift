//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    internal let InstaPetTableViewCellIdentifier: [String] = ["InstaDogCellIdentifier", "InstaCatCellIdentifier"]
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    internal var instaDogs: [InstaDog] = []
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    internal var sectionNames = ["InstaCats", "InstaDogs"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.getInstaCats(from: instaCatEndpoint)
        
        //This is from our local files
        //        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
        //            self.instaCats = instaCatsAll
        //        }
        self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instacats: [InstaCat]?) in
            if let igCat = instacats {  
                self.instaCats = igCat
                DispatchQueue.main.async {
                    InstaDogFactory.manager.getInstaDogs(apiEndpoint: self.instaDogEndpoint) { (instadogs:[InstaDog]?) in
                        if let igDog = instadogs {
                            self.instaDogs = igDog
                            DispatchQueue.main.async {
                                self.tableView.reloadData()               }
                        }
                    }
                }
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     func getInstaCats(from apiEndpoint: String) {
     if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
     
     let session = URLSession(configuration: URLSessionConfiguration.default)
     
     session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
     
     if error != nil {
     print("Error encountered!: \(error!)")
     }
     
     if let validData: Data = data {
     print(validData) // not of much use other than to tell us that data does exist
     
     // let allTheCats = InstaCatFactory.manager.getInstaCats(from: validData)
     //This doesn't work because you're trying to return from a function that returns void. The Alternative would be :
     
     if let instaCats = InstaCatFactory.manager.getInstaCats(from: validData) {
     self.instaCats = instaCats
     DispatchQueue.main.async {
     self.tableView.reloadData()
     }
     }
     
     
     }
     
     //this line is very important
     }.resume()
     }
     }
     */
    
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
                    if let allTheCats: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: validData) {
                        
                        callback(allTheCats)
                    }
                }
                // 4a. ALSO THIS!
            }.resume()
            
        }
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instaCats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaPetTableViewCellIdentifier[indexPath.section], for: indexPath)
        
        
        print("Index: (Row: \(indexPath.row), Section: \(indexPath.section)) InstaDogCount: \(instaDogs.count)")
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = self.instaCats[indexPath.row].name
            cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
        case 1:
            cell.textLabel?.text = self.instaDogs[indexPath.row].name
            cell.detailTextLabel?.text = self.instaDogs[indexPath.row].description
            cell.imageView?.image = UIImage(named: instaDogs[indexPath.row].imageName)
        default:
            return cell
        }
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    
}
