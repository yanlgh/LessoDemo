//
//  CustomerInfoViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/19.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Contacts
import Alamofire
import SwiftyJSON
import RealmSwift

//typealias ContactsHandler = (contacts:[CNContact],error:NSError?)->Void


class CustomerInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var orderedContacts = [String:[Customer]]()
    var sortedContactKeys = [String]()
    var dataArr:NSArray!
    var sectionSource:Dictionary<String,NSMutableArray>! = Dictionary<String,NSMutableArray>()
    var headerSource:NSMutableArray!
    var view_dataSource:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let btnAdd:UIBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showAddWin")
        self.navigationItem.setRightBarButtonItem(btnAdd, animated: false)
        let nib = UINib(nibName: "ContactCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        view_dataSource=NSMutableArray()
        headerSource=NSMutableArray()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.getContacts()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAddWin(){
        self.performSegueWithIdentifier("addCustomer", sender: self)
    }
    
    /**
     获取数据
     */
    func getContacts(){
        self.sectionSource["#"]=NSMutableArray()
        for i in 65...90{
            let key = String(format: "%c", i)
            sectionSource[key] = NSMutableArray()
            headerSource.addObject(key)
        }
        Alamofire.request(.GET, "http://10.10.6.130:8000/api/AppCustomerInfo/Getmst_CustomerInfo")
            .responseJSON{
                response in
                let array = JSON(response.result.value!).arrayObject
                self.dataArr = array! as NSArray
                self.sortArray()
                self.tableView.reloadData()
        }
    }
    
    /**
     根据首字母排序
     */
    func sortArray(){
        for customer in dataArr{
            var str:NSString!=NSString(UTF8String: customer["Name"] as! String)
            if(str=="") {continue}
            if str.containsString(" "){
                str = str.stringByReplacingOccurrencesOfString(" ", withString: "")
            }
            
            var key:String!
            key = String(format: "%c", pinyinFirstLetter(str.characterAtIndex(0))).uppercaseString
            if str.length <= 0 || isPureInt(key) || key == "_"{
                key = "#"
            }
            //self.headerSource.addObject(key)
            self.sectionSource[key.uppercaseString]?.addObject(customer)
        }
    }
    

    func isPureInt(string:String!) ->Bool{
        let scan:NSScanner! = NSScanner(string: string)
        var result = 0
        return scan.scanInteger(&result) && scan.atEnd
    }
    
    /**
     列表元素
     
     - parameter tableView: <#tableView description#>
     - parameter indexPath: <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContactCell
        //if(sectionSource.count>0){
            let sectionData=self.sectionSource[self.headerSource.objectAtIndex(indexPath.section) as! String]
            //if(sectionData?.count>0){
                let user = sectionData?.objectAtIndex(indexPath.row)
                let customer = Customer()
                customer.name = user!["Name"] as! String
                customer.tel = user!["Tel"] as! String
                cell.updateContactsinUI(customer, indexPath: indexPath, subtitleType: SubtitleCellValue.Phonenumer)
        
            //}
     
        //}
        
        return cell
    }
    
    /**
     行高
     
     - parameter tableView: <#tableView description#>
     - parameter indexPath: <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    /**
     没字母则隐藏
     
     - parameter tableView: <#tableView description#>
     - parameter section:   <#section description#>
     
     - returns: <#return value description#>
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.sectionSource[self.headerSource.objectAtIndex(section) as! String]?.count<=0){
        return 0}
        return 25
    }
    
    /**
     <#Description#>
     
     - parameter tableView: <#tableView description#>
     - parameter section:   <#section description#>
     
     - returns: <#return value description#>
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.sectionSource[self.headerSource.objectAtIndex(section) as! String] {
            return data.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return headerSource.count
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.headerSource as [AnyObject] as? [String]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerSource.objectAtIndex(section) as? String
    }
}
