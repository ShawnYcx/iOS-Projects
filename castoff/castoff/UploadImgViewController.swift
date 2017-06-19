//
//  UploadImgViewController.swift
//  castoff
//
//  Created by shawn yap on 3/23/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import UIKit

class UploadImgViewController: UIViewController {

    @IBOutlet weak var imgHolder: UIView!
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var imgButton: UIButton!
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Step2Upload" {
            
        }
    }

    @IBAction func imgDidPressed(_ sender: Any) {
        self.showPickerAction()
    }
}

extension UploadImgViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func selectPhoto(tap: UITapGestureRecognizer) {
//        self.showPickerAction()
//    }
    
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
        
        guard (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil else {
            print("Something went wrong.")
            return
        }
    
        print("Something did not go wrong.")
        selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.Img.image = selectedPhoto
        self.imgButton.titleLabel?.text = "Pick another"
    
        
        self.dismiss(animated: true, completion: nil)
    }
}
