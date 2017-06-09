//
//  SignupViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/16/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class SignupViewController: UIViewController {
    
    let loginToList = "LoginToList"   

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.selectPhoto(tap:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    @IBAction func CloseDidTouch(_ sender: AnyObject) {
        view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300) ) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func SignUpDidTapped(_ sender: AnyObject) {
        guard let email = textFieldEmail.text, !email.isEmpty,
            let password = textFieldPassword.text, !password.isEmpty,
            let username = textFieldUsername.text, !username.isEmpty else {
                return
        }
        
        var data = NSData()
        data = UIImageJPEGRepresentation(profileImage.image!, 0.1)! as NSData
        
        // Signing up
        SVProgressHUD.show(withStatus: "Please wait..")
        DataService.dataService.SignUp(username: username, email: email, password: password, data: data)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    // MARK: Return Key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    // MARK: Gesture
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}
