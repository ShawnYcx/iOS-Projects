//
//  ChatViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/28/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import Firebase
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    var roomId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = FIRAuth.auth()?.currentUser{
            self.senderId = currentUser.uid
            self.senderDisplayName = "\(currentUser.displayName!)"
            observeMessage()
        }
        
        
//        left & right button needs to be changed
//        self.inputToolbar.contentView.backgroundColor = AppStyle.appearance.app_Color
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    func observeUsers(id: String){
        FIRDatabase.database().reference().child("users").child(id).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]
            {
                let avatarUrl = dict["profileUrl"] as! String
                self.setupAvatar(url: avatarUrl, messageId: id)
            }
        })
    }
    
    func setupAvatar(url: String, messageId: String) {
        if url != "" {
            if url.hasPrefix("gs://"){
                let gsPath = FIRStorage.storage().reference(forURL: url)
                gsPath.data(withMaxSize: INT64_MAX, completion: { (data, error) in
                    if let error = error {
                        print("Error downloading thumbnail \(error.localizedDescription)")
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
                    self.avatarDict[messageId] = userImg
                    self.collectionView.reloadData()
                })
            }else {
                let fileUrl = NSURL(string: url)
                let data = NSData(contentsOf: fileUrl! as URL)
                let image = UIImage(data: data as! Data)
                let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
                self.avatarDict[messageId] = userImg
                self.collectionView.reloadData()
            }
        } else {
            self.avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
        }
        collectionView.reloadData()
    }
    
    func observeMessage(){
        DataService.dataService.MESSAGE_REF.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let mediaType = dict["mediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderDisplayName = dict["displayname"] as! String
                
                self.observeUsers(id: senderId)
                
                switch mediaType {
                    case "TEXT":
                        let text = dict["text"] as? String
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
                        break
                    case "PHOTO":

//                            let url = NSURL(string: fileUrl)
//                            let data = NSData(contentsOf: url! as URL)
//                            let picture = UIImage(data: data! as Data)
//                            let photo = JSQPhotoMediaItem(image: picture)
                            let photo = JSQPhotoMediaItem(image: nil)
                            let fileUrl = dict["fileUrl"] as! String                        
                            let downloader = SDWebImageDownloader.shared()
                            downloader?.downloadImage(with: NSURL(string: fileUrl)! as URL!,
                                                     options: [],
                                                     progress: nil, completed: { (image, data, error, finished) in
                                                        DispatchQueue.main.async {
                                                            photo?.image = image
                                                            self.collectionView.reloadData()
                                                        }
                            })
                        
                            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
//
                            if self.senderId == senderId {
                                photo!.appliesMediaViewMaskAsOutgoing = true
                            }else {
                                photo!.appliesMediaViewMaskAsOutgoing = false
                            }
                        break
                    case "VIDEO":
                        let fileUrl = dict["fileUrl"] as! String
                        let video = NSURL(string: fileUrl)
                        let videoItem = JSQVideoMediaItem(fileURL: video as URL!, isReadyToPlay: true)
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
                        
                        if self.senderId == senderId {
                            videoItem!.appliesMediaViewMaskAsOutgoing = true
                        }else {
                            videoItem!.appliesMediaViewMaskAsOutgoing = false
                        }
                    break
                    
                    default:
                        print("Unknown data type")
                        break
                }
                
                self.collectionView.reloadData()
                self.scrollToBottom(animated: false)
            }
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let messageData = ["text": text, "senderId": senderId, "displayname": senderDisplayName, "mediaType": "TEXT"]
        DataService.dataService.CreateNewMessage(info: messageData)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.showPickerAction()
    }
    
    // MARK: JSQMessagesCollectionViewDataSource
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: AppStyle.appearance.app_Color)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
    
        return self.avatarDict[message.senderId]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // If media is a picture
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Save media to server
            DataService.dataService.sendMedia(picture: picture, video: nil, senderId: self.senderId, senderDisplayName: self.senderDisplayName)
        } // else if media is a video
        else if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
            
            // Save media to server
            DataService.dataService.sendMedia(picture: nil, video: video, senderId: self.senderId, senderDisplayName: self.senderDisplayName)
        }
        
        // Dismiss UIImagePickerController and reload data
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    // MARK: MediaPicker
    func showPickerAction() {
        //Create the alert controller
        let actionSheetController: UIAlertController = UIAlertController(title: "Media Message", message: "Please select a media", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        //        //Create and add "Camera" action
        //        let camAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
        //        }
        
        //Create and add "Video Library" action
        let videoLibrary: UIAlertAction = UIAlertAction(title: "Video Library", style: .default) { action -> Void in
            self.getMediaFrom(type: kUTTypeMovie)
        }
        
        //Create and add "Photo Library" action
        let photoLibrary: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            self.getMediaFrom(type: kUTTypeImage)
        }
        
        //        actionSheetController.addAction(camAction)
        actionSheetController.addAction(photoLibrary)
        actionSheetController.addAction(videoLibrary)
        actionSheetController.addAction(cancelAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func getMediaFrom(type: CFString) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        present(mediaPicker, animated: true, completion: nil)
    }

}




