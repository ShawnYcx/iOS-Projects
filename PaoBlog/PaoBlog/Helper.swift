//
//  Helper.swift
//  PaoBlog
//
//  Created by shawn yap on 12/29/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import GoogleSignIn

private struct Constants {
    static let ID = "id"
    static let CONTACTS = "contacts"
    static let EMAIL = "email"
    static let USERS = "users"
    static let DISPLAYNAME = "displayname"
    static let FRIENDS = "friends"
}

private struct Views {
    static let MAIN_STORYBOARD = "Main"
    static let MAIN_VC = "MainTab"
    static let LogIn_VC = "LogInVC"
    static let CreateRoom_VC = "CreateRoomVC"
}

protocol FetchData: class {
    func dataReceived(contacts: [Contact])
}


class Helper {
    static let helper = Helper()
    
    weak var delegate: FetchData?
    
    func switchToNavigationViewController() {
        let storyboard = UIStoryboard(name: Views.MAIN_STORYBOARD, bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Views.MAIN_VC) as! MainTabbarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
    }
    
    func switchToLogInViewController() {
        let storyboard = UIStoryboard(name: Views.MAIN_STORYBOARD, bundle: nil)
        let logInVC = storyboard.instantiateViewController(withIdentifier: Views.LogIn_VC) as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController = logInVC
    }
    
    func logInWithGoogle(authentication: GIDAuthentication){
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user: FIRUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                
                let newUser = FIRDatabase.database().reference().child(Constants.USERS).child(user!.uid)
                newUser.setValue(["id": "\(user!.uid)", "email": user!.email, "displayname": "\(user!.displayName!)", "profileUrl": "\(user!.photoURL!)"])
                
                self.switchToNavigationViewController()
            }
        })
    }
    
    func getContacts(){
        
        FIRDatabase.database().reference().child(Constants.USERS).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            var contacts = [Contact]()
            
            if let myContacts = snapshot.value as? NSDictionary {
                for (key, value) in myContacts {
                    if let contactData = value as? NSDictionary{
                        if let name = contactData[Constants.DISPLAYNAME] as? String {
                            if name != FIRAuth.auth()?.currentUser?.displayName{
                                let id = key as! String
                                if let email = contactData[Constants.EMAIL] as? String{
                                    let newContact = Contact(id: id, name: name, email: email)
                                    contacts.append(newContact)
                                }
                            }
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts)
        })
    }
    
    func fetchUserFriends(){
        
        let userID = FIRAuth.auth()?.currentUser!.uid
            FIRDatabase.database().reference().child(Constants.USERS).child(userID!).child(Constants.FRIENDS).observe(.value, with: { (snapshot: FIRDataSnapshot) in
        
                var contacts = [Contact]()
                print(snapshot)
                if let myContacts = snapshot.value as? NSDictionary {
                    for (key, value) in myContacts {
                        if let contactData = value as? NSDictionary{
                            if let name = contactData[Constants.DISPLAYNAME] as? String {
                                if let email = contactData[Constants.EMAIL] as? String {
                                    let id = key as! String
                                    let newContact = Contact(id: id, name: name, email: email)
                                    contacts.append(newContact)
                                    print(contacts)
//                                print("key: \(key) value: \(value)")
                                }
                            }
                        }
                    }
                }
            self.delegate?.dataReceived(contacts: contacts)
            })
        
        
//        FIRDatabase.database().reference().child(Constants.USERS).child().observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
//            var contacts = [Contact]()
//            
//            if let myContacts = snapshot.value as? NSDictionary {
//                for (key, value) in myContacts {
//                    if let contactData = value as? NSDictionary{
//                        if let name = contactData[Constants.DISPLAYNAME] as? String {
//                            if name != FIRAuth.auth()?.currentUser?.displayName{
//                                let id = key as! String
//                                if let email = contactData[Constants.EMAIL] as? String{
//                                    let newContact = Contact(id: id, name: name, email: email)
//                                    contacts.append(newContact)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            self.delegate?.dataReceived(contacts: contacts)
//        })
    }

    func addContact(contact: Dictionary <String, Any>) {
        let id = DataService.dataService.currentUser?.uid
        let friendsPath = FIRDatabase.database().reference().child(Constants.USERS).child(id!).child(Constants.FRIENDS)
        var dict = contact
        
        if let id = dict[Constants.ID] as? String{
            friendsPath.setValue(id)
            friendsPath.child(id).setValue([Constants.EMAIL: dict[Constants.EMAIL],
                                            Constants.DISPLAYNAME: dict[Constants.DISPLAYNAME]])
        }
    }
    
}
