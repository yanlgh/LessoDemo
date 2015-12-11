//
//  AddCustomerViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/23.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import Alamofire


class AddCustomerViewController: FormViewController {
    
    var customer = Customer()
    let realm = try!Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnAdd:UIBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "btnOK")
        self.navigationItem.setRightBarButtonItem(btnAdd, animated: false)
        URLRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .blueColor() }
        LabelRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orangeColor()  }
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .orangeColor() }
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() }
        
        form =
            
            Section()
            
            <<< NameRow() {
                $0.title =  "客户名称"
                $0.tag = "customerName"
            }
            
            <<< PhoneRow() {
                $0.title = "手机"
                $0.tag = "phone"
            }
            
            +++ Section()
            
            <<< PhoneRow() {
                $0.title = "电话"
                $0.tag = "tel"
            }
            
            <<< EmailRow() {
                $0.title = "邮箱"
                $0.tag = "email"
            }
            
      
            +++ Section()
        
            <<< NameRow() {
                $0.title =  "地址"
                $0.tag = "address"
            }
        
        
            <<< NameRow() {
                $0.title =  "联系人"
                $0.tag = "connecter"
            }

            <<< NameRow() {
                $0.title =  "职位"
                $0.tag = "post"
            }
        
        
            +++ Section()
        
            <<< AlertRow<String>() {
                $0.title = "客户状态"
                $0.selectorTitle = "状态列表"
                $0.tag = "customerStatus"
                $0.options = CustomerStatus
                
                }.onChange{ row in
                    self.customer.customerStatus = CustomerStatus.indexOf(row.value!)
                    
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purpleColor()
            }
            <<< AlertRow<String>() {
                $0.title = "客户级别"
                $0.selectorTitle = "级别列表"
                $0.tag = "CustomerLevel"
                $0.options = CustomerLevel
                
                }.onChange{ row in
                    self.customer.customerLevel = CustomerLevel.indexOf(row.value!)!
              
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purpleColor()
        }


    }
    
    func btnOK(){
        
        customer.name = form.rowByTag("customerName")?.baseValue as! String
        customer.address = form.rowByTag("address")?.baseValue as! String
        customer.tel = form.rowByTag("tel")?.baseValue as! String
        customer.phone = form.rowByTag("phone")?.baseValue as! String
        customer.post = form.rowByTag("post")?.baseValue as! String
        customer.email = form.rowByTag("email")?.baseValue as! String
        
        try! realm.write{
            self.realm.add(self.customer)
        }
        
        let profile = realm.objects(Profile)
        let id = profile[0]["id"] as! String
        let url = webConfig.webPoint+webConfig.appCustomerInfo
        let params = [
                "Name": customer.name,
                "Address": customer.address,
                "Post": customer.post,
                "Tel": customer.tel,
                "Email": customer.email,
                "Create_UID": id,
                "CustomerStatus": customer.customerStatus,
                "CustomerLevel": customer.customerLevel

        ]
        self.pleaseWait()
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON{
                resp in
                print(resp.result.value)
                
                self.clearAllNotice()
                self.noticeSuccess("添加成功", autoClear: true, autoClearTime: 1)
                //self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
        }

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
