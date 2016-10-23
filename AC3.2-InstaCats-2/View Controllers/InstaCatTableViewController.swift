//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    internal let instaCatJSONFileName: String = "InstaCats.json" //local cat data
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw" //remote cat data
    
    internal var instaCats: [InstaCat] = [] //stick our cat objects in this drawer which is currently empty
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier" //sign designating that this shelf is a cat shelf

    internal let instaCatFactory = InstaCatFactory() //you give it JSON and it gives you cats
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName /*instaCatEndpoint*/) {
            self.instaCats = instaCatsAll //when the view loads up, churn out cats & put them in an array...if the Factory can accept the JSON we give it. If not, do nothing
        }
        
        instaCatFactory.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in //here is the callback. 
            if instaCats != nil { //if we have cats...
                for cat in instaCats! { //for each individual cat
                    print(cat.description) //print the cat's description to console. If nothing prints, we'll know it's because the array is still empty.
                    
                    DispatchQueue.main.async { //do this stuff out of sync and on the main thread
                        self.instaCats = instaCats! //unwrap these cats no matter what
                        self.tableView.reloadData() //present these cats in the view
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //one big shelving unit
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instaCats.count //make as many shelves as there are cats to shelf
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //how to make shelves
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath) //our shelves are going to be of the instaCatTableViewCellIdentifier kind, and we are going to reuse them as we scroll up and down because they're all the same kind anyway
        
        cell.textLabel?.text = self.instaCats[indexPath.row].name //the big text on the shelf is the cat's name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description //the little text on the shelf is the cat's description
        
        return cell //once we've set up our shelf, present it inside the shelving unit
    }

}
