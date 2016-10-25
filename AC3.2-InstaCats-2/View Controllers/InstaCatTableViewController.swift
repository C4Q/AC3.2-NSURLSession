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
    internal let instaDogJSONFileName: String = "InstaDogs.json"
    
    internal var instaCats: [InstaCat] = []
    internal var instaDogs: [InstaDog] = []
    
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    internal let instaCatFactoryy = InstaCatFactory()
    internal let instaDogFactoryy = InstaDogFactory()
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
            self.instaCats = instaCatsAll
        }
        
        if let instaDogsAll: [InstaDog] = InstaDogFactory.makeInstaDogs(fileName: instaDogJSONFileName) {
            self.instaDogs = instaDogsAll
        }
        
        
        instaCatFactoryy.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
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
        
        instaDogFactoryy.getInstaDogs(apiEndpoint: instaDogEndpoint) { (instaDogs: [InstaDog]?) in
            if instaDogs != nil {
                for dog in instaDogs! {
                    print(dog.name)
                    
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "InstaCats"
        }
        if section == 1 {
            return "InstaDogs"
        }
        return nil
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
          
            
            return cell
            
        }
        
        
        
        
    }
    
  
    
    

}
