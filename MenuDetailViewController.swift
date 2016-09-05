//
//  MenuDetailViewController.swift
//  productMenu
//
//  Created by 徐常璿 on 2016/8/16.
//  Copyright © 2016年 Eric Hsu. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var itemImageView:UIImageView!

    var items:Menu!
    
    var itemLocation:String!
    
    var index:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        title = items.item
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return 40.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell",forIndexPath: indexPath) as! MenuDetailTableViewCell
        
        let imgURL = NSURL(string:items.itemImage)
        if let imageData = NSData(contentsOfURL: imgURL!) {
            itemImageView.image = UIImage(data: imageData)
        }
//        itemImageView.image = (UIImage(named: items.itemImage))
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = title
            
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = items.type
            
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = items.location
            itemLocation = items.location
            
            
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = items.phone
            
            
        case 4:
            cell.fieldLabel.text = "Store"
            cell.valueLabel.text = items.store
            
        case 5:
            cell.fieldLabel.text = "opentime"
            cell.valueLabel.text = items.opentime
            
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "showDetail"{
        

                let destinationController = segue.destinationViewController as! MapViewController
            
                destinationController.items = items
                destinationController.itemLocation = "itemLocation"
            
        }

    }

    @IBOutlet weak var callAPhone: UIButton!
    @IBAction func makeACall(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string :items.phone)!)
    }
}
