//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    internal let instaCatJSONFileName: String = "InstaCats.json" //cat names etc.
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw" //cat pix
    
    internal var instaCats: [InstaCat] = [] //stick our cat objects in this drawer which is currently empty
    
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier" //sign for each cat shelf in view

    internal let instaCatFactoryy = InstaCatFactory() //you give it JSON and it gives you cats
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName) {
            self.instaCats = instaCatsAll //when the view loads up, churn out cats & put them in an array...if the Factory can accept the JSON we give it. If not, do nothing
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
