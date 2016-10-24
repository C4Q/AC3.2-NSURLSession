//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewController: UITableViewController {
    
    //MARK: Cat setup
    
    internal let instaCatJSONFileName: String = "InstaCats.json" //local cat data
    internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw" //remote cat data
    internal var instaCats: [InstaCat] = [] //stick our cat objects in this drawer which is currently empty
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier" //sign designating that this shelf is a cat shelf
    
    //MARK: Dog setup
    
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98" //remote dog data
    internal var instaDogs: [InstaDog] = [] //stick our dog objects in this drawer which is currently empty
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier" //sign designating that this shelf is a dog shelf
    
    //MARK: Both
    
    internal var sectionTitle = ["InstaCats", "InstaDogs"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let instaCatsAll: [InstaCat] = InstaCatFactory.makeInstaCats(fileName: instaCatJSONFileName /*instaCatEndpoint*/) {
            self.instaCats = instaCatsAll //when the view loads up, churn out cats & put them in an array...if the Factory can accept the JSON we give it. If not, do nothing
        }
        
        self.getInstaCats(apiEndpoint: instaCatEndpoint) { (instaCats: [InstaCat]?) in //here is the callback.
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
        return 2 //two shelving units
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.instaCats.count //in the first unit, make as many shelves as there are cats to shelf
        } else if section == 1 {
            return self.instaDogs.count //in the second unit, make as many shelves for dogs etc.
        } else {
            return 0 //XCode compiler insists on this else statement even though it seems unnecessary...
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //how to make shelves
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath) //our shelves are going to be of the instaCatTableViewCellIdentifier kind, and we are going to reuse them as we scroll up and down because they're all the same kind anyway
        
        cell.textLabel?.text = self.instaCats[indexPath.row].name //the big text on the shelf is the cat's name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description //the little text on the shelf is the cat's description
        
        return cell //once we've set up our shelf, present it inside the shelving unit
    }
    
    /*
     ok, so singletons. singletons have inits that are private. if we remove the designation 'private' from our factory, other instances can create more factories. it will no longer be single. public init =/= singleton. BUT we need to have a public init to get catFactory in our view controller running. If it's private, we can't initialize it and call catFactory in viewDidLoad to make us cats. we can get around this difficulty by putting the remote data method in our view controller and calling self within viewDidLoad to get our catFactory pumping out cats. Unfortunately, this somewhat breaks the MVC pattern, in that we are sticking stuff from the model inside a controller. It's better to get working code than to rigidly adhere to the rules...
     */
    
    /// Creates `[InstaCat]` from valid REMOTE `Data`
    func getInstaCats(apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
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
                    
                    // 5. reuse our code to make some cats from Data
                    let allTheCats: [InstaCat]? = InstaCatFactory.manager.getInstaCats(from: validData)
                    print("I'm super before")
                    callback(allTheCats)
                }
                }.resume()
            print("I'm super after")
        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section]
//    }
}
