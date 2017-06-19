//
//  GalleryTableViewController.swift
//  castoff
//
//  Created by shawn yap on 3/21/17.
//  Copyright © 2017 YStudio. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController, FetchData {

    let cell_Id = "items"
    var items = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.dataService.delegate = self
        Service.dataService.loadAllItems()
    }
    
    func dataReceived(items: [Items]) {
        self.items = items
        self.tableView.reloadData()
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_Id, for: indexPath) as! GalleryCell

         cell.configCell(title: items[indexPath.item].title,
                         price: items[indexPath.item].price,
                         image: items[indexPath.item].image)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDescription" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView?.indexPath(for: cell)
            let destination = segue.destination as! ProductViewController
            
            
//            destination.productImage.image = cell.imageView?.image
            destination.title = self.items[(indexPath?.item)!].title
            print(self.items[(indexPath?.item)!].description)
            
            destination.item = (["description": self.items[(indexPath?.item)!].description,
                                 "oldPrice": self.items[(indexPath?.item)!].oldPrice,
                                 "price": self.items[(indexPath?.item)!].price,
                                 "image": self.items[(indexPath?.item)!].image])
            
            print(destination.item)
//            destination.productDescription?.text = self.items[(indexPath?.item)!].description
//            destination.productOldPrice.text = self.items[(indexPath?.item)!].oldPrice
//            destination.productPrice.text = self.items[(indexPath?.item)!].price
        }

    }

}
