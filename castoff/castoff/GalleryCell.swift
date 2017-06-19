//
//  GalleryCell.swift
//  castoff
//
//  Created by shawn yap on 3/21/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class GalleryCell: UITableViewCell {

    private var contacts: NSDictionary = [:]
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    
    func configCell(title: String, price: String, image: String){
        
        self.titleText.text = title
        self.productPrice.text = price
        
        let imageRef = FIRStorage.storage().reference(withPath: "listingimages/\(image)")
        
        imageRef.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
            if (error != nil){
                print(error)
            } else {
                let myImage: UIImage! = UIImage(data: data!)
                self.productImg.image = myImage.scaleImageToSize(newSize: self.productImg.frame.size)

            }
        }
    
    }
    
}

