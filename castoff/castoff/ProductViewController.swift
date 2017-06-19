//
//  ProductViewController.swift
//  castoff
//
//  Created by shawn yap on 3/22/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProductViewController: UIViewController {
    
    var item: NSDictionary = [:]
    
    @IBOutlet weak var ImageContainer: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productOldPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadImg(img: (item["image"] as? String)!)
        
        self.productDescription.text = item["description"] as? String
        self.productPrice.text = item["price"] as? String
        self.productOldPrice.text = item["oldPrice"] as? String
        
    }

    func loadImg(img: String) {
        let imageRef = FIRStorage.storage().reference(withPath: "listingimages/\(img)")
        
        imageRef.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
            if (error != nil){
                print(error)
            } else {
                let myImage: UIImage! = UIImage(data: data!)
                self.productImage.image = myImage.scaleImageToSize(newSize: self.ImageContainer.frame.size)
            }
        }
    }

}

// MARK: - Image Scaling.
extension UIImage {
    
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
