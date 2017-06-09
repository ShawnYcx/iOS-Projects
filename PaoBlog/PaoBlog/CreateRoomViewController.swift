//
//  CreateRoomViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/16/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase

class CreateRoomViewController: UIViewController{

    @IBOutlet weak var choosePhotoBtn: UIButton!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var captionLbl: UITextField!
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!

    @IBAction func CloseDidTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateRoomDidTapped(_ sender: Any) {
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(photoImg.image!, 0.1)! as NSData
        DataService.dataService.CreateNewRoom(user: FIRAuth.auth()!.currentUser!, caption: captionLbl.text!, data: data)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension CreateRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func selectPhoto_DidTapped(_ sender: Any) {
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
        selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.photoImg.image = selectedPhoto
        picker.dismiss(animated: true, completion: nil)
        self.choosePhotoBtn.setTitle("", for: .normal)
    }
}

