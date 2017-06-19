//
//  Service.swift
//  castoff
//
//  Created by shawn yap on 3/20/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

let rootRef = FIRDatabase.database().reference()

protocol FetchData: class {
    func dataReceived(items: [Items])
}

class Service{
    static let dataService = Service()
    
    weak var delegate: FetchData?
    
    private var _BASE_REF = rootRef
    private var _LISTING_REF = rootRef.child("listings")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    var LISTING_REF: FIRDatabaseReference {
        return _LISTING_REF
    }
    
    func uploadNewItem(info: Dictionary <String, Any>) {
//        title: String, description: String, price: String, oriPrice: String, data: NSData
        BASE_REF.childByAutoId().setValue(info)
    }
    
    func loadAllItems() {
        var items = [Items]()
        LISTING_REF.observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? NSDictionary {
                let newItem = Items(title: (item["title"] as? String)!,
                                    price: (item["price"] as? String)!,
                                    oldPrice: (item["oldprice"] as? String)!,
                                    description: (item["description"] as? String)!,
                                    availability: (item["availability"] as? String)!,
                                    image: (item["image"] as? String)!)
                items.append(newItem)
            }
            self.delegate?.dataReceived(items: items)
        })
    }
}

