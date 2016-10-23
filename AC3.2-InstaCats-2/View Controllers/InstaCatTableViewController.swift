//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    internal var instaCats: [InstaCat] = []

    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    internal var instaDogs: [InstaDog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InstaCatFactory.getInstaCats(apiEndpoint: instaCatEndpoint) { (returnedInstaCats: [InstaCat]?) in
            if let unwrappedReturnedInstaCats = returnedInstaCats {
                self.instaCats = unwrappedReturnedInstaCats
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
        
        InstaDogFactory.getInstaDogs(apiEndpoint: instaDogEndpoint) { (returnedInstaDogs: [InstaDog]?) in
            if let unwrappedReturnedInstaDogs = returnedInstaDogs {
                self.instaDogs = unwrappedReturnedInstaDogs
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
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
            let thisInstaDog = self.instaDogs[indexPath.row]
            cell.textLabel?.text = thisInstaDog.name
            let detailMessage = "Posts:\(thisInstaDog.posts)  Followers:\(thisInstaDog.followers)  Following:\(thisInstaDog.following)"
            cell.detailTextLabel?.text = detailMessage
            cell.imageView?.image = UIImage(named: thisInstaDog.imageName)
            cell.imageView?.layer.cornerRadius = 15
            cell.imageView?.layer.masksToBounds = true
        
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
