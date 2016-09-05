//
//  MenuTableViewController.swift
//  productMenu
//
//  Created by 徐常璿 on 2016/8/15.
//  Copyright © 2016年 Eric Hsu. All rights reserved.
//

import UIKit

//定義一個反向傳回值的closure
typealias completion = (youWantToSave:NSArray) -> Void

//接反向傳回的值
var storeInfoArray:[Menu] = []

//接收解析Json資料的暫時陣列
var temp:[Menu] = []

//獨立書店公開資料網址
let url = "http://localhost/apiforios.php"

var searchResults:[Menu] = []


class MenuTableViewController: UITableViewController{
    
//    var items:[Menu] = [Menu(item: "Nayung", itemImage: "1.jpg", type: "idol", location: "Test Test Test Test Test Test TestTest Test TestKorean", isVisited: false),
//                        Menu(item: "Mina", itemImage: "2.jpg", type: "idol", location: "Korean", isVisited: false),
//                        Menu(item: "Nayung", itemImage: "1.jpg", type: "idol", location: "Korean", isVisited: false),
//                        Menu(item: "Mina", itemImage: "2.jpg", type: "idol", location: "Korean", isVisited: false),
//                        Menu(item: "Nayung", itemImage: "1.jpg", type: "idol", location: "Korean", isVisited: false)]
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        呼叫Connection這方法
        Connection(url) { (youWantToSave) in
            
            storeInfoArray =  youWantToSave as! [Menu]
            
            //重新整理cell算碰UI，所以要在主執行序動作
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
               
            })
        }
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return 20.0
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.active ? searchResults.count : storeInfoArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuTableViewCell
        if (searchController.active) {
            cell.nameLabel.text = searchResults[indexPath.row].item
            cell.thumbnailImageView.image = UIImage(named: searchResults[indexPath.row].itemImage)
            cell.typeLabel.text = searchResults[indexPath.row].store
        } else {
        cell.nameLabel.text = storeInfoArray[indexPath.row].item
//        cell.thumbnailImageView.image = UIImage(named: storeInfoArray[indexPath.row].itemImage)
//            cell.thumbnailImageView.image = UIImage(contentsOfFile: storeInfoArray[indexPath.row].itemImage)
            let imgURL = NSURL(string:storeInfoArray[indexPath.row].itemImage)
            if let imageData = NSData(contentsOfURL: imgURL!) {
                  cell.thumbnailImageView.image = UIImage(data: imageData)
                }
            
        cell.typeLabel.text = storeInfoArray[indexPath.row].store
        }
//        print(storeInfoArray[indexPath.row])
        
        return cell
    }
 
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! MenuDetailViewController
                destinationController.items = storeInfoArray[indexPath.row]
                
            }
        }
    }
    

    func Connection(url:String,Completion:completion){
        let url = NSURL(string:url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in//先判斷網址是否為nil
            
            if error == nil {
                do{
                    let jsonObj =
                        try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                    
                    for i in 0..<jsonObj.count  {
                        
                        //有幾筆資料就創造幾個自定義的書店類別
                        let item = Menu()
//                        print(jsonObj)
                        //將需要的資料分別解析出來，並存入相對應變數
                        item.item = jsonObj[i]["name"] as! String
                        item.location = jsonObj[i]["address"] as! String
                        item.phone = jsonObj[i]["phone"] as! String
                        item.type = jsonObj[i]["type"] as! String
                        item.store = jsonObj[i]["intro"] as! String
                        item.itemImage = jsonObj[i]["representImage"] as! String
                        item.opentime = jsonObj[i]["openTime"] as! String
                        //將存好的每筆資料依序存入暫存陣列
                        temp.append(item)
                        
                    }
                    
                    //將存好的暫存陣列放入反向傳值的closure
                    Completion(youWantToSave: temp)
                    
                    
                }
                catch{
                    print(error)}//如果有錯就印到偵錯區
            }
        }
        
        task.resume()//必加
    }
    

    
}

extension MenuTableViewController:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let options: NSStringCompareOptions = [NSStringCompareOptions.CaseInsensitiveSearch, NSStringCompareOptions.WidthInsensitiveSearch]
        let text = searchController.searchBar.text!
        
        searchResults = storeInfoArray.filter() {item in
            let string = "\(item.item) \(item.itemImage) \(item.type) \(item.store)"
            return string.rangeOfString(text, options: options) != nil
        }
        tableView.reloadData()
    }
        
}


