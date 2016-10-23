//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    internal let TableViewCellIdentifier: [String] = ["InstaCatCellIdentifier", "InstaDogCellIdentifier"]
//    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
//    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal let instaDogJSONFileName: String = "InstaDogs.json"
    internal var instaCats: [InstaCat] = []
    internal var instaDogs: [InstaDog] = []
    var instaCatFactory = InstaCatFactory()
    var instaDogFactory = InstaDogFactory()
    
    //Pointing a specific point in the internet
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instaCatFactory.getInstaCats(apiEndpoint: instaCatEndpoint) { (returnedInstaCats:[InstaCat]?) in
            if let unwrapedReturnedInstaCats = returnedInstaCats{
                self.instaCats = unwrapedReturnedInstaCats
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        instaDogFactory.getInstaDogs(apiEndpoint: instaDogEndpoint){(returnedInstaDogs:[InstaDog]?) in
            if let unwrappedReturnedInstaDogs = returnedInstaDogs{
                self.instaDogs = unwrappedReturnedInstaDogs
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
        //        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
        //            self.instaCats = instaCatsAll
        //        }
        //        if let instaDogsAll: [InstaDog] = InstaDogFactory.makeInstaDogs(fileName: instaDogJSONFileName){
        //            self.instaDogs = instaDogsAll
        //        }
        print("******************")
        dump(instaDogs)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.instaCats.count
        case 1: return self.instaDogs.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "InstaCats"
        case 1: return "InstaDogs"
        default: return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier[indexPath.section], for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.instaCats[indexPath.row].name
            cell.detailTextLabel?.text = self.instaCats[indexPath.row].description
        } else if indexPath.section == 1 {
            let dogs = self.instaDogs[indexPath.row]
            cell.imageView?.image = UIImage(named: dogs.imageName)
            cell.textLabel?.text = dogs.name
            cell.detailTextLabel?.text = "Posts: \(dogs.posts), Followers: \(dogs.followers), Following: \(dogs.following)"
        } else {
            cell.textLabel?.text = " "
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selectedInstaCats = self.instaCats[indexPath.row]
            let url = selectedInstaCats.instagramURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 1:
            let selectedInstaDogs = self.instaDogs[indexPath.row]
            guard let url = URL(string: selectedInstaDogs.instagram) else {return}
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default: return
        }
    }
}
