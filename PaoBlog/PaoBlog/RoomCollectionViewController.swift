//
//  RoomCollectionViewController.swift
//  PaoBlog
//
//  Created by shawn yap on 12/16/16.
//  Copyright © 2016 YStudio. All rights reserved.
//

import UIKit
import Firebase

class RoomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DataService.dataService.FetchDataFromServer { (room) in
//            if room.userUID == DataService.dataService.currentUser!.uid{
//                self.rooms.append(room)
//                let indexPath = NSIndexPath(item: self.rooms.count - 1, section: 0)
//                self.collectionView?.insertItems(at: [indexPath as IndexPath])
//            }
//        }
        
        DataService.dataService.ROOM_REF.observe(.childAdded, with: {(snapshot) -> Void in
            let room = Room(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, Any>)
            self.rooms.append(room)
            let indexPath = NSIndexPath(item: self.rooms.count - 1, section: 0)
            self.collectionView?.insertItems(at: [indexPath as IndexPath])
        })
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roomCell", for: indexPath) as! RoomCollectionViewCell
        
        let room = rooms[indexPath.row]
        
        // Configure the cell
        cell.configureCell(room: room)
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2 - 5, height: view.frame.size.width/2 - 5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatSegue" {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell)
            let room = rooms[indexPath!.item]
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.roomId = room.id
        }
    }

}
