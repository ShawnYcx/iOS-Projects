//
//  Items.swift
//  castoff
//
//  Created by shawn yap on 3/21/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import Foundation

class Items{
    
    private var _title = "";
    private var _image = "";
    private var _price = "";
    private var _oldPrice = "";
    private var _description = "";
    private var _availability = "";
    
    init(title: String, price: String, oldPrice: String, description: String, availability: String, image: String) {
        
        _title = title;
        _price = price;
        _oldPrice = oldPrice;
        _description = description;
        _availability = availability;
        _image = image
        
    }
    
    var title: String {
        return _title;
    }
    
    var price: String {
        return _price;
    }
    
    var oldPrice: String {
        return _oldPrice;
    }
    
    var description: String {
        return _description;
    }
    
    var availability: String {
        return _availability;
    }
    
    var image: String {
        return _image;
    }
    
}
