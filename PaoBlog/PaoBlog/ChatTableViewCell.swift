//
//  ChatTableViewCell.swift
//  PaoBlog
//
//  Created by shawn yap on 12/24/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase

class SerialOperationQueue: OperationQueue
{
    override init()
    {
        super.init()
        maxConcurrentOperationCount = 1
    }
}

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    let queue = SerialOperationQueue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    func configCell(idUser: String, message: Dictionary<String, Any>) {

        DispatchQueue.global(qos: .background).async {
            self.messageTextLabel.text = message["message"] as! String
            
            DataService.dataService.PEOPLE_REF.child(idUser).observe(.value, with: { (snapshot) -> Void in
                let dict = snapshot.value as! Dictionary<String, Any>
                let imageUrl = dict["profileImage"] as! String
                if imageUrl.hasPrefix("gs://"){
                    FIRStorage.storage().reference(forURL: imageUrl).data(withMaxSize: INT64_MAX, completion: { (data, error) in
                        if let error = error {
                            print("Error downloading: \(error.localizedDescription)")
                            return
                        }
                        self.profileImageView.image = UIImage.init(data: data! as Data)
                    })
                }
            })
        }
        
    }
}
