//
//  RoomCollectionViewCell.swift
//  PaoBlog
//
//  Created by shawn yap on 12/20/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase

class RoomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailPhoto: UIImageView!
    @IBOutlet weak var captionLbl: UILabel!
    
    func configureCell(room: Room) {
        self.captionLbl.text = room.caption
        if let imageUrl = room.thumbnail {
            if imageUrl.hasPrefix("gs://") {
                FIRStorage.storage().reference(forURL: imageUrl).data(withMaxSize: INT64_MAX, completion: { (data, error) in
                    if let error = error {
                        print("Error downloading thumbnail \(error.localizedDescription)")
                        return
                    }
                    self.thumbnailPhoto.image = UIImage.init(data: data!)
                })
            }else if let url = NSURL(string: imageUrl), let data = NSData(contentsOf: url as URL) {
                self.thumbnailPhoto.image = UIImage.init(data: data as Data)
            }
        }
    }
}
