////
////  ChatViewController.swift
////  PaoBlog
////
////  Created by shawn yap on 12/16/16.
////  Copyright © 2016 YStudio. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//private struct Constants {
//    static let cellIdMessageReceived = "MessageCellYou"
//    static let cellIdMessageSent = "MessageCellMe"
//}
//
//
//class ChatViewController2: UIViewController {
//    
//    @IBOutlet weak var chatTextField: UITextField!
//    @IBOutlet weak var tableView: UITableView!
//    var roomId: String!
//    var messages: [FIRDataSnapshot] = []
//    var heightAtIndexPath: NSMutableArray!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.title = "Room Chat"
//        
//        DataService.dataService.fetchMessageFromServer(roomId: self.roomId) { (snap) in
//            self.messages.append(snap)
//            self.tableView.reloadData()
//        }
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.tableView.reloadData()
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(showOrHideKeyboard), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showOrHideKeyboard), name: .UIKeyboardWillHide, object: nil)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object:nil)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object:nil)
//    }
//    
//    @IBOutlet weak var constraintToBottomView: NSLayoutConstraint!
//    
//    func showOrHideKeyboard(notification: NSNotification) {
//        if notification.name == .UIKeyboardWillShow {
//            adjustingHeight(show: true, notification: notification)
//            
//        } else if notification.name == .UIKeyboardWillHide {
//            adjustingHeight(show: false, notification: notification)
//        }
//    }
//    
//    func moveToLastMessage() {
//        if self.tableView.contentSize.height > self.tableView.frame.height {
//            let contentOfSet = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.height)
//            self.tableView.setContentOffset(contentOfSet, animated: true)
//        }
//    }
//    
//    func adjustingHeight(show:Bool, notification:NSNotification) {
//        
//        if let keyboardInfo: Dictionary = notification.userInfo {
//            let keyboardFrame:CGRect = (keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//            let animationDurarion = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
//            let changeInHeight = (keyboardFrame.height)
//            if show {
//                UIView.animate(withDuration: animationDurarion, animations: { () in
//                    self.constraintToBottomView.constant += changeInHeight
//                    self.view.layoutIfNeeded()
//                }) { (completion: Bool) -> Void in
//                    self.moveToLastMessage()
//                }
//            } else {
//                UIView.animate(withDuration: animationDurarion, animations: { () in
//                    self.constraintToBottomView.constant = 0
//                    self.view.layoutIfNeeded()
//                })  { (completion: Bool) -> Void in
//                    self.moveToLastMessage()
//                }
//            }
//        }
//    }
//    
//    
//
//    @IBAction func SendButtonDidTapped(_ sender: Any) {
//        guard let textField = chatTextField.text, !textField.isEmpty else {
//            print("error: Empty String")
//            return
//        }
//        
//        if let user = FIRAuth.auth()?.currentUser {
//            DataService.dataService.CreateNewMessage(userId: user.uid,
//                                                     roomId: roomId,
//                                                     textMessage: chatTextField.text!)
//        }else {
//            // No user is signed in
//        }
//        self.chatTextField.text = nil
//    }
//}
//
//extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let messageSnapshot = messages[indexPath.row]
//        let message = messageSnapshot.value as! Dictionary<String, Any>
//        let messageId = message["senderId"] as! String
//        if messageId == DataService.dataService.currentUser?.uid {
//            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdMessageSent, for: indexPath) as! ChatTableViewCell
//            cell.configCell(idUser: messageId, message: message)
//            cell.layoutIfNeeded()
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdMessageReceived, for: indexPath) as! ChatTableViewCell
//            cell.configCell(idUser: messageId, message: message)
//            cell.layoutIfNeeded()
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//}
//
//extension ChatViewController: UITextFieldDelegate {
//    // MARK: Gesture
//    @IBAction func userTappedBackground(sender: AnyObject) {
//        view.endEditing(true)
//    }
//}
