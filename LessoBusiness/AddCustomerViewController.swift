//
//  AddCustomerViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/23.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Eureka


class AddCustomerViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btnAdd:UIBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "btnOK")
        self.navigationItem.setRightBarButtonItem(btnAdd, animated: false)
        URLRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .blueColor() }
        LabelRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orangeColor()  }
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .orangeColor() }
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() }
        
        form =
            
            Section()
            
            <<< NameRow() {
                $0.title =  "客户名称"
                $0.tag="customerName"
            }
            
            <<< PhoneRow() {
                $0.title = "手机"
            }
            
            
            +++ Section()
            
            <<< PhoneRow() {
                $0.title = "电话"
            }
            
            <<< EmailRow() {
                $0.title = "邮箱"
            }
            
      
            +++ Section()
        
            <<< NameRow() {
                $0.title =  "地址"
            }
        
        
            <<< NameRow() {
                $0.title =  "联系人"
            }

            <<< NameRow() {
                $0.title =  "职位"
                
            }
        
        
            +++ Section()
        
            <<< AlertRow<String>() {
                $0.title = "客户状态"
                $0.selectorTitle = "状态列表"
                $0.options = ["a", "b", "c", "d", "e", "f"]
                $0.value = "b"
                
                }.onChange { row in
                    print(row.value)
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purpleColor()
            }
    }
    
    func btnOK(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
