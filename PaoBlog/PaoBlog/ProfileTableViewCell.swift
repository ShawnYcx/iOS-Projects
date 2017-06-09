//
//  ProfileTableViewCell.swift
//  PaoBlog
//
//  Created by shawn yap on 12/24/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    
    func configCell () {
        
        if let user = DataService.dataService.currentUser {
            
            profileImage.layer.cornerRadius = profileImage.frame.size.height/2
            profileImage.clipsToBounds = true
            
            username.text = user.displayName
            email.text = user.email
            if user.photoURL != nil {
                if let data = NSData(contentsOf: user.photoURL!){
                    self.profileImage.image = UIImage.init(data: data as Data)
                }
            }
        } else {
            // No user is signed in
        }

    }
    
}
