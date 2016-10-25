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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
            //Find out if InstaCats array is empty or not
            if instaCats != nil {
                //Once you know you have values, reload the data. Enclose it in DispathQueue to make it load automaticcally instead of having to scroll to update the data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                
                self.instaCats = instaCats!
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath) as! InstaCatTableViewCell
        
        let cat = instaCats[indexPath.row]
        cell.instaCatNameLabel.text = cat.name
        cell.instaCatDescriptionLabel.text = cat.description
        
        if let catName = cell.instaCatNameLabel.text {
            switch catName {
            case "Nala Cat":
                cell.instaCatImageView.image = UIImage(named: "princess_monster_truck")
            case "Princess Monster Truck":
                cell.instaCatImageView.image = UIImage(named: "nala_cat")
            case "Grump Cat":
                cell.instaCatImageView.image = UIImage(named: "grumpy_cat")
            default:
                print("Image Loading Failed")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(instaCats[indexPath.row].instagramURL)
    }
   
    //MAKES API REQUEST
    func getInstaCats(apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
        //Tries to convert string to URL
        if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
            
            // 1. URLSession/Configuration
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            //2. dataTaskWithURL
            session.dataTask(with: validInstaCatEndpoint) { (data: Data?, URLResponse: URLResponse?, error: Error?) in
                
                // 3. check for errors right away
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                
                // 4. printing out the data
                if let validData: Data = data {
                    print(validData)
                    
                    
                    // 5. reuse our code to make some cats from Data
                    if let instaCats: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: validData) {
                        print(instaCats)
                        callback(instaCats)
                    
                    }
                }
            }.resume() //needs to be called to actually launch the task
            //4a. Also this!
        }
    }
    //Because of asynchronous network requests, we can't have the function return the InstaCats data. If you tried to return the data, the tableView would not populate data because the data hasn't been loaded by the time the view has been loaded. The data ends up loading a few seconds after the view loads, so there is nothing to populate at that given point in time
    
}






