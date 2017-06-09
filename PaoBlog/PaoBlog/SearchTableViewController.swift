//
//  SearchTableViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/30/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, FetchData {

    private let CELL_ID = "cell"
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.helper.delegate = self
        Helper.helper.getContacts()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! SearchTableViewCell
    
        cell.configCell(id: contacts[indexPath.item].id,
                        displayname: contacts[indexPath.item].name,
                        email: contacts[indexPath.item].email)
        
        return cell
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
