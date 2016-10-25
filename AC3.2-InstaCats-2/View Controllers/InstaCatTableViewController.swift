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
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    internal var instaCats: [InstaCat] = []
    
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    internal var instaDogs: [InstaDog] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InstaDogFactory.manager.makeInstaDogs(from: self.instaDogEndpoint) { (dogs: [InstaDog]?) in
            if let goodDogs = dogs {
                self.instaDogs = goodDogs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        
        InstaCatFactory.manager.getInstaCatsTwo(from: self.instaCatEndpoint) { (cats: [InstaCat]?) in
            if let goodCats = cats {
                self.instaCats = goodCats
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    
       
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            title = "InstaCats"
        }
        if section == 1 {
            title = "InstaDogs"
        }
        return title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if instaDogs.count>0 && instaCats.count>0 {
        
        return 2
    }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return instaCats.count
        case 1:
            return instaDogs.count
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0 {
        cell.textLabel?.text = self.instaCats[indexPath.row].name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
        return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.instaDogs[indexPath.row].name
            cell.detailTextLabel?.text = self.instaDogs[indexPath.row].formattedStats()
            cell.imageView?.image = self.instaDogs[indexPath.row].profileImage()
            return cell
        }
        return cell
}
}
