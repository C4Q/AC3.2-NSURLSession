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
    
    // instaDog lesson
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    internal var instaDogs: [InstaDog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInstaCats(from: instaCatEndpoint) { (cats: [InstaCat]?) in
            if cats != nil {
                self.instaCats = cats!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        InstaDogParser().parseDogs(from: instaDogEndpoint) { (dogs: [InstaDog]?) in
            if dogs != nil {
                self.instaDogs = dogs!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getInstaCats(from apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
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

                let allTheCats: [InstaCat]? = InstaCatParser().parseInstaCats(from: validData)
                callback(allTheCats)
            }
            }.resume() // Other: Easily forgotten, but we need to call resume to actually launch the task
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
        switch section {
        case 0: return self.instaCats.count
        default: return self.instaDogs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.instaCats[indexPath.row].name
            cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.instaDogs[indexPath.row].name
            cell.detailTextLabel?.text = self.instaDogs[indexPath.row].formattedStats()
            cell.imageView?.image = self.instaDogs[indexPath.row].profileImage()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "InstaCats"
        default: return "InstaDogs"
        }
    }
}
