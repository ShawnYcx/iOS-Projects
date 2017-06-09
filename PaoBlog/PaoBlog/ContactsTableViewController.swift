//
//  ContactsTableViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/30/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController, FetchData {

    private let CELL_ID = "cell"
    var contacts = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.helper.delegate = self
        Helper.helper.fetchUserFriends()
        self.tableView.reloadData()
    }

    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        self.tableView.reloadData()
    }
   
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        cell.textLabel?.text = self.contacts[indexPath.item].name
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "CreateMessage" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView?.indexPath(for: cell)
            let destination = segue.destination as! NewMessageFacadeViewController
            destination.title = self.contacts[(indexPath?.item)!].name
            destination.dict = (["displayname": self.contacts[(indexPath?.item)!].name,
                                 "email": self.contacts[(indexPath?.item)!].email,
                                 "id": self.contacts[(indexPath?.item)!].id])
        }
     }
 

}
