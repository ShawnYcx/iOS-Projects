//
//  SearchTableViewCell.swift
//  PaoBlog
//
//  Created by shawn yap on 12/30/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    private var contacts: NSDictionary = [:]
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var AddContactButton: UIButton!
    
    func configCell(id: String, displayname: String, email: String){
        let dict = ["id": id, "displayname": displayname, "email": email]
        print(id)
        self.contacts = dict as NSDictionary
        self.textLabel?.text = displayname
    }
    
    @IBAction func AddDidTapped(_ sender: Any) {
        print(self.contacts)
        Helper.helper.addContact(contact: self.contacts as! Dictionary<String, Any>)
    }
}
