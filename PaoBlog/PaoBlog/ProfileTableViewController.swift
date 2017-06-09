//
//  ProfileTableViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/16/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileTableViewController: UITableViewController{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UILabel!
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//        self.navigationItem.rightBarButtonItem = editButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileTableViewController.selectPhoto(tap:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        
        if let user = DataService.dataService.currentUser {
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
    
    override func viewDidAppear(_ animated: Bool) {
        // Edit happens here
    }
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        self.showPickerAction()
    }
    
    func showPickerAction() {
        //Create the alert controller
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose action", message: "", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            //Just dismiss the action sheet
        }
        
        //Create and add "Camera" action
        let camAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera;
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        //Create and add "Camera" action
        let libAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary;
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        actionSheetController.addAction(camAction)
        actionSheetController.addAction(libAction)
        actionSheetController.addAction(cancelAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var data = NSData()
        
        selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismiss(animated: true, completion: nil)
        SVProgressHUD.show(withStatus: "Please wait...")
        
        data = UIImageJPEGRepresentation(profileImage.image!, 0.1)! as NSData
        DataService.dataService.changeProfileImage(data: data as NSData)
    }
}

extension ProfileTableViewController: UITextFieldDelegate {
//    // MARK: Gesture
//    @IBAction func userTappedBackground(sender: AnyObject) {
//        view.endEditing(true)
//    }
}
