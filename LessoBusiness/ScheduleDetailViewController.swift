//
//  ScheduleDetailViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/26.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScheduleDetailViewController: UIViewController,UIActionSheetDelegate {

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scheduleTitle: UILabel!
   
    @IBOutlet weak var scheduleTime: UILabel!
    
    @IBOutlet weak var scheduleContent: UITextView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var schedule = Schedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "日程详细"
        let btnEdit:UIBarButtonItem = UIBarButtonItem.init(title: "编辑", style: UIBarButtonItemStyle.Done, target: self, action: "btnEdit")
        self.navigationItem.setRightBarButtonItem(btnEdit, animated: false)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        scheduleTitle.text = schedule.Title
        scheduleTime.text = schedule.Date
        scheduleContent.text=schedule.Content
        scheduleContent.editable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDelete(sender: UIBarButtonItem) {
        let actionSheet:UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("删除日程")
        actionSheet.showFromToolbar(self.toolBar)
    }
    
    /**
     - parameter actionSheet: <#actionSheet description#>
     - parameter buttonIndex: <#buttonIndex description#>
     */
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            break
        case 1:
            self.pleaseWait()
            let url = "http://10.10.6.130:8000/api/AppSchedule/Deletemst_Schedule/"+self.schedule.id
            Alamofire.request(.DELETE, url)
                .responseJSON{
                    resp in
                    self.clearAllNotice()
                    if JSON(resp.result.value!)["rst"] == 1{
                        self.noticeSuccess("删除成功", autoClear: true, autoClearTime: 1)
                    }
                    self.navigationController?.popViewControllerAnimated(true)
            }
            break
        default:
            break
        }
    }
    
    func btnEdit(){
        self.performSegueWithIdentifier("editSchedule", sender: self)
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editSchedule"){
            let nvc = segue.destinationViewController as! UINavigationController //使用segue
            let vc = nvc.topViewController as! AddScheduleViewController
            vc.schedule = schedule
            vc.action = "edit"
        }
    }
}
