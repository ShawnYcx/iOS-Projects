 //
//  Room.swift
//  PaoBlog
//
//  Created by shawn yap on 12/20/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import Foundation
import UIKit

class Room{
    var caption: String!
    var thumbnail: String!
    var id: String!
    var userUID: String!

    init(key: String, snapshot: Dictionary<String, Any>) {
        self.id = key
        self.caption = snapshot["caption"] as! String
        self.thumbnail = snapshot["thumbnailUrlFromStorage"] as! String
        self.userUID = snapshot["addedBy"] as! String
    }

}
