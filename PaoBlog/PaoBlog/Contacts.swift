//
//  Contacts.swift
//  PaoBlog
//
//  Created by shawn yap on 12/30/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import Foundation

class Contact {
    private var _name = ""
    private var _id = ""
    private var _email = ""
    
    init(id: String, name: String, email: String) {
        _id = id
        _name = name
        _email = email
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var id: String {
        return _id
    }
    
}
