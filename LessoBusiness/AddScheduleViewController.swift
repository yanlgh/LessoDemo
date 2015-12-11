//
//  AddScheduleViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/6.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import Alamofire
import SwiftyJSON

class AddScheduleViewController: FormViewController {

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    //@IBOutlet weak var textView: UITextView!
    
    var schedule = Schedule()
    var action = ""
    
    @IBAction func btnCancel(sender: UIBarButtonItem) {
        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(action == "edit"){
            self.title="编辑日程"
            self.navigationItem.rightBarButtonItem?.title = "完成"
        }
        initForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     初始化表单
     - returns: <#return value description#>
     */
    func initForm(){
        
        form =
            
            TextRow("title").cellSetup { cell, row in
                cell.textField.placeholder = "标题"
                row.value = self.schedule.Title
            }
            
            <<< TextAreaRow("content") {
                $0.placeholder = "内容"
                $0.value =  self.schedule.Content
            }
            
            +++ Section()
            
            <<< DateRow("date") { $0.value = NSDate(); $0.title = "安排日期" }
    }
    
    
    
    @IBAction func addClicked(sender: UIBarButtonItem) {
        self.pleaseWait()
        var url = ""
        var params = Dictionary<String,String>()
        if(action == "edit"){
            url = "http://10.10.6.130:8000/api/AppSchedule/Putmst_Schedule/" + self.schedule.id
            self.schedule.Title = form.rowByTag("title")?.baseValue as! String
            self.schedule.Content = form.rowByTag("content")?.baseValue as! String
            params = [
                "title" : self.schedule.Title,
                "content" : self.schedule.Content,
                "arrangeDate" : self.schedule.Date,
                "arrangePersonId" : self.schedule.ArrangePerson
            ]
            Alamofire.request(.PUT, url, parameters: params)
                .responseJSON{
                    resp in
                    print(resp.result.value)
                    self.clearAllNotice()
                    self.noticeSuccess("保存成功", autoClear: true, autoClearTime: 1)
                    self.dismissViewControllerAnimated(true, completion: nil)
            }
            return
        }
        
        let schedule = Schedule()
        schedule.Title = form.rowByTag("title")?.baseValue as! String
        schedule.Content = form.rowByTag("content")?.baseValue as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = form.rowByTag("date")?.baseValue as! NSDate
        let strDate = dateFormatter.stringFromDate(date)
        schedule.Date = strDate
        let realm = try!Realm()
        try! realm.write{
            realm.add(schedule)
        }
        let profile = realm.objects(Profile)
        let id = profile[0]["id"] as! String
        url = "http://10.10.6.130:8000/api/AppSchedule/Postmst_Schedule"
        params = [
            "title" : schedule.Title,
            "content" : schedule.Content,
            "arrangeDate" : schedule.Date,
            "arrangePersonId" : id
        ]
        
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON{
                resp in
                print(resp.result.value)
                
                self.clearAllNotice()
                self.noticeSuccess("添加成功", autoClear: true, autoClearTime: 1)
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
