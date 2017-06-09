//
//  DataService.swift
//  PaoBlog
//
//  Created by shawn yap on 12/17/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SVProgressHUD
import GoogleSignIn

let rootRef = FIRDatabase.database().reference()

class DataService {
    
    static let dataService = DataService()
    
    private var _BASE_REF = rootRef
    private var _ROOM_REF = rootRef.child("rooms")
    private var _MESSAGE_REF = rootRef.child("messages")
    private var _PEOPLE_REF = rootRef.child("users")
    
    var currentUser: FIRUser? {
        return FIRAuth.auth()!.currentUser!
    }
    
    var MESSAGE_REF: FIRDatabaseReference {
        return _MESSAGE_REF
    }
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var ROOM_REF: FIRDatabaseReference {
        return _ROOM_REF
    }
    
    var PEOPLE_REF: FIRDatabaseReference {
        return _PEOPLE_REF
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var fileUrl: String!
    
    func CreateNewRoom(user: FIRUser, caption: String, data: NSData) {
        let filePath = "\(user.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate))"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child(filePath).put(data as Data, metadata: metaData) { (metadata, error) in
            if let error = error{
                print("Error uploading: \(error.localizedDescription)")
                return
            }
            // Create a url for data (thumbnail image)
            self.fileUrl = metadata!.downloadURLs![0].absoluteString
            if let user = FIRAuth.auth()?.currentUser {
                let idRoom = self.BASE_REF.child("rooms").childByAutoId()
                idRoom.setValue(["caption": caption, "thumbnailUrlFromStorage": self.storageRef.child(metadata!.path!).description, "fileUrl": self.fileUrl, "addedBy": user.uid])
            }
        }
    }
    
    func FetchDataFromServer(callback: @escaping (Room)-> ()) {
        
        DataService.dataService.ROOM_REF.observe(.childAdded, with: { (snapshot) in
            let room = Room(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, Any>)
            callback(room)
        })
        
    }
    
    func SignUp(username: String, email: String, password: String, data: NSData) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let changeRequest = user?.profileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
            let filePath = "\(user!.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate))"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.child(filePath).put(data as Data, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                
                self.fileUrl = metadata?.downloadURLs![0].absoluteString
                let changeRequestPhoto = user!.profileChangeRequest()
                changeRequestPhoto.photoURL = NSURL(string: self.fileUrl) as URL?
                changeRequestPhoto.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }else {
                        print("profile updated")
                    }
                })
        
                self.PEOPLE_REF.child((user?.uid)!).setValue(["id": user!.uid, "email": email, "displayname": username, "profileUrl": self.storageRef.child((metadata?.path)!).description])
            })
            SVProgressHUD.showSuccess(withStatus: "Succeeded.")
        })
        
        FIRAuth.auth()!.signIn(withEmail: email,
                               password: password)
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: email,
                               password: password) { (user, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    
                                    let alertView = UIAlertView(title: "Notice", message: "Incorrect email or password entered.", delegate: self, cancelButtonTitle: "Dismiss")
                                    alertView.alertViewStyle = .default
                                    SVProgressHUD.dismiss()
                                    alertView.show()
                                    return
                                
                                }else {
                                    SVProgressHUD.showSuccess(withStatus:"Have fun!")
                                }
                                
        }
        
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            Helper.helper.switchToLogInViewController()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    // Update Profile
    func UpdateProfile(username: String) {
        let user = FIRAuth.auth()?.currentUser!
        let changeRequestProfile = user?.profileChangeRequest()
        if user != nil {
            changeRequestProfile?.displayName = username
            SVProgressHUD.showSuccess(withStatus: "Saved")
        }
    }
    
    func changeProfileImage(data: NSData){
        let user = FIRAuth.auth()?.currentUser!
        let filePath = "\(user!.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate))"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).put(data as Data, metadata: metaData) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error.localizedDescription)")
                return
            }
            self.fileUrl = metadata!.downloadURLs![0].absoluteString
            let changeRequestPhoto = user?.profileChangeRequest()
            changeRequestPhoto?.photoURL = NSURL(string: self.fileUrl) as URL?
            changeRequestPhoto?.commitChanges(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "Network error")
                    return
                }else {
                    print("profile updated")
                }
            })
        SVProgressHUD.showSuccess(withStatus: "Image Updated")
        }
    }
    
//    func CreateNewMessage(userId: String, roomId: String, textMessage: String) {
//        let idMessage = MESSAGE_REF.childByAutoId()
//        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(["message": textMessage, "senderId": userId])
//        DataService.dataService.ROOM_REF.child(roomId).child("messages").child(idMessage.key).setValue(true)
//    }
    
    func CreateNewMessage(info: Dictionary <String, Any>) {
        let idMessage = MESSAGE_REF.childByAutoId()
        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(info)
    }
    
    func sendMedia(picture: UIImage?, video: NSURL?, senderId: String!, senderDisplayName: String!){
        // If picture is not nil = user selected a picture
        if let picture = picture {
            let filePath = "\(DataService.dataService.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
            let data = UIImageJPEGRepresentation(picture, 0.1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            storageRef.child(filePath).put(data! as Data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                
                let messageData = ["fileUrl": fileUrl, "senderId": senderId, "displayname": senderDisplayName, "mediaType": "PHOTO"]
                DataService.dataService.CreateNewMessage(info: messageData)
                
            }
        } else if let video = video {
            let filePath = "\(DataService.dataService.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
            let data = NSData(contentsOf: video as URL)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            storageRef.child(filePath).put(data! as Data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                
                let messageData = ["fileUrl": fileUrl, "senderId": senderId, "displayname": senderDisplayName, "mediaType": "VIDEO"]
                DataService.dataService.CreateNewMessage(info: messageData)
                
            }
        }
        
    }

    
    func fetchMessageFromServer(roomId: String, callback: @escaping (FIRDataSnapshot) -> ()){
        DataService.dataService.ROOM_REF.child(roomId).child("messages").observe(.childAdded,
                                                                                with: {snapshot -> Void in
                                                                                    DataService.dataService.MESSAGE_REF.child(snapshot.key).observe(.value,
                                                                                                                                                    with: { snap -> Void in
                                                                                                                                                        callback(snap)
                                                                                    })
        })
    }
}
