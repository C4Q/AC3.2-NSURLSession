//
//  InstaDogTableViewController.swift
//  AC3.2-InstaCats-2
//
//  Created by Erica Y Stevens on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaDogTableViewController: UITableViewController {
    

    internal var instaDogs: [InstaDog] = []
    internal let InstaDogTableViewCellIdentifier: String = "InstaDogCellIdentifier"
    internal let instaDogEndpoint: String = "https://api.myjson.com/bins/58n98"
    internal let instaDogJSONFileName: String = "InstaDogs.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getInstaDogs(apiEndpoint: instaDogEndpoint) { (instaDogs: [InstaDog]?) in
            //Find out if InstaCats array is empty or not
            if instaDogs != nil {
                //Once you know you have values, reload the data. Enclose it in DispathQueue to make it load automaticcally instead of having to scroll to update the data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.instaDogs = instaDogs!
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(instaDogs[indexPath.row].instagramURL)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instaDogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaDogTableViewCellIdentifier, for: indexPath) as! InstaDogTableViewCell
        
        let dog = instaDogs[indexPath.row]
        cell.instaDogNameLabel.text = dog.name
        cell.instaDogStatsLabel.text = "Posts: \(dog.posts), Followers: \(dog.followers), Following: \(dog.following)"
        cell.instaDogImage.image = UIImage(named: dog.imageName)
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MAKES API REQUEST
    func getInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void) {
        //Tries to convert string to URL
        if let validInstaDogEndpoint: URL = URL(string: apiEndpoint) {
            
            // 1. URLSession/Configuration
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            //2. dataTaskWithURL
            session.dataTask(with: validInstaDogEndpoint) { (data: Data?, URLResponse: URLResponse?, error: Error?) in
                
                // 3. check for errors right away
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                
                // 4. printing out the data
                if let validData: Data = data {
                    print(validData)
                    
                    
                    // 5. reuse our code to make some cats from Data
                    if let instaDogs: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: validData) {
                        print(instaDogs)
                        callback(instaDogs)
                        
                    }
                }
                }.resume() //needs to be called to actually launch the task
            //4a. Also this!
        }
    }


}
