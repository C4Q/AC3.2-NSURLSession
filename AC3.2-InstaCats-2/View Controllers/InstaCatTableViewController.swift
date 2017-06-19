//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
    let instaCatJSONFileName: String = "InstaCats.json"
    var instaCats: [InstaCat] = []
    
    let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if let instaCatsAll: [InstaCat] = InstaCatParser().parseCats(from: instaCatJSONFileName) {
        //     self.instaCats = instaCatsAll
        // }
        
        _ = self.getInstaCats(from: instaCatEndpoint)
    }
    
    func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
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
                    
                    // 5. reuse our code to make some cats from Data
                    let allTheCats: [InstaCat]? = InstaCatParser().parseInstaCats(from: validData)
                    print("All the cats!! \(String(describing: allTheCats))")
                    
                    return allTheCats
                }
                
                // 4a. ALSO THIS!
                }.resume()
        }
        return nil
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instaCats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.instaCats[indexPath.row].name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
        
        return cell
    }
    
}
