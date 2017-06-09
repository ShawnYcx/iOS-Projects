//
//  LoginViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/15/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!

    // MARK: Constants
    let loginToList = "LoginToList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = "975646796136-ch917211eecnbb7ejgrk6ipfki3l463b.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
//                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                Helper.helper.switchToNavigationViewController()
            }else {
                print("Not authorized")
            }
        }
    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        guard let email = textFieldLoginEmail.text, !email.isEmpty,
            let password = textFieldLoginPassword.text, !password.isEmpty else {
                SVProgressHUD.showError(withStatus: "Email/Password can't be empty")
            return
        }
        
        SVProgressHUD.show(withStatus: "Signing in... ")
        DataService.dataService.login(email: textFieldLoginEmail.text!,
                                      password: textFieldLoginPassword.text!)
    }
    
    @IBAction func GoogleSignInDidTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        Helper.helper.logInWithGoogle(authentication: user.authentication)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        else if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}
