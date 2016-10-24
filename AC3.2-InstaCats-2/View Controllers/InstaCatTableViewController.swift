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
    internal var instaDogs: [InstaDog] = []
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
        //    self.instaCats = instaCatsAll
        //}
        InstaCatFactory.manager.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in
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
        
        InstaDogFactory.manager.getInstaDogs(apiEndpoint: instaDogEndpoint) { (instaDogs: [InstaDog]?) in
            if instaDogs != nil {
                for dog in instaDogs! {
                    print(dog.formattedStats())
                    
                    DispatchQueue.main.async {
                        self.instaDogs = instaDogs!
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "InstaCats"
        case 1:
            return "InstaDogs"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.instaCats.count
        case 1:
            return self.instaDogs.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.instaCats[indexPath.row].name
            cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath)
            cell.textLabel?.text = self.instaDogs[indexPath.row].name
            cell.detailTextLabel?.text = self.instaDogs[indexPath.row].formattedStats()
            cell.imageView?.image = self.instaDogs[indexPath.row].profileImage()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            UIApplication.shared.open(instaCats[indexPath.row].instagramURL, options: [:], completionHandler: nil)
        case 1:
            UIApplication.shared.open(instaDogs[indexPath.row].instagramURL, options: [:], completionHandler: nil)
        default:
            break
        }
    }
}
