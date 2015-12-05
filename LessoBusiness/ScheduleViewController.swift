//
//  ScheduleViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/5.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON



class ScheduleViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var btnRightDown: UIBarButtonItem!
    
    @IBOutlet weak var txtCurrentPerson: UILabel!
    
    
    var datesWithEvent = [String]()
    
    
    var animationFinished = true
    var arrSchedule = [Schedule]()
    let realm = try!Realm()
    var selectedDate = NSDate()
    var staffArray:NSArray!
    var currentPersonId = ""
    var tmpSchedule = Schedule()
    var jsonSchedule = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let btnAdd:UIBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showAddWin")
        self.navigationItem.setRightBarButtonItem(btnAdd, animated: false)
        tableView.delegate=self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        calendar.selectDate(NSDate())
        let profile = realm.objects(Profile)
        currentPersonId = profile[0]["id"] as! String
        txtCurrentPerson.text = profile[0]["name"] as? String
        loadDaysWithEvent()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 查看下属
extension ScheduleViewController:UIAlertViewDelegate{
    
    /**
     弹出下属列表
     - parameter sender: <#sender description#>
     */
    @IBAction func lookforSub(sender: UIBarButtonItem) {
        
        let url = "http://10.10.6.130:8000/api/AppAccount/GetFollowers/" + currentPersonId
        Alamofire.request(.GET, url)
            .responseJSON{
                response in
                var json = JSON(response.result.value!)
                let subStaffs = JSON(json["rows"].object)
                self.staffArray = subStaffs.arrayObject! as NSArray
                let alertView:UIAlertView = UIAlertView(title: "请选择", message: "", delegate: self, cancelButtonTitle: "取消")
                for staff in self.staffArray{
                    alertView.addButtonWithTitle(staff["name"] as? String)
                }
                alertView.show()
        }
    }
    
    /**
     选择下属
     - parameter alertView:   <#alertView description#>
     - parameter buttonIndex: <#buttonIndex description#>
     */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 0){return}
        self.currentPersonId = self.staffArray[buttonIndex-1]["id"] as! String
        self.txtCurrentPerson.text = self.staffArray[buttonIndex-1]["name"] as? String
        let url = "http://10.10.6.130:8000/api/AppSchedule/Getmst_Schedule/"+self.currentPersonId+"?date="+self.calendar.stringFromDate(self.calendar.selectedDate)
        Alamofire.request(.GET, url)
            .responseJSON{
                resp in
                print(resp.result.value)
        }
    }
}


// MARK: - 日历控件
extension ScheduleViewController : FSCalendarDataSource,FSCalendarDelegate{
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCalendarTheme()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.calendar(self.calendar, didSelectDate: self.calendar.selectedDate)
    }
    
    /**
     设置日历样式
     */
    func setCalendarTheme(){
        self.calendar.appearance.titleTextSize = 18     //日历日期字体大小
        self.calendar.appearance.headerTitleTextSize = 20
    }
    
    /**
     加载有事件的日期
     */
    func loadDaysWithEvent(){
        let dateFormat = String(self.calendar.yearOfDate(self.calendar.selectedDate)) + "/" + String(self.calendar.monthOfDate(self.calendar.selectedDate))
        let url = "http://10.10.6.130:8000/api/AppSchedule/GetDaysWithEvent?uid=" + self.currentPersonId + "&date=" + dateFormat
        Alamofire.request(.GET, url)
            .responseJSON{
                resp in
                self.datesWithEvent = JSON(resp.result.value!).arrayObject! as NSArray as! [String]
                self.calendar.reloadData()
        }
        
    }
    
    /**
     点击日期
     - parameter calendar: <#calendar description#>
     - parameter date:     <#date description#>
     */
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
//        selectedDate = calendar.selectedDate
//        let formatter = NSDateFormatter()
//        formatter.timeZone = NSTimeZone.localTimeZone()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let selectedDay  = formatter.stringFromDate(selectedDate)
//        let predicate = NSPredicate(format: "Date = %@", selectedDay)
//        let schedules = realm.objects(Schedule).filter(predicate)
//        arrSchedule.removeAll()
//        for result in schedules{
//            arrSchedule.append(result)
//        }
        
        let url = "http://10.10.6.130:8000/api/AppSchedule/Getmst_Schedule/" + self.currentPersonId + "?date=" + self.calendar.stringFromDate(self.calendar.selectedDate)
        Alamofire.request(.GET, url)
            .responseJSON{
                resp in
                self.jsonSchedule = JSON(resp.result.value!).arrayObject! as NSArray
                //print(self.jsonSchedule)
                self.tableView.reloadData()
        }
        
    }
    
    /**
     有事件的日期下面加点
     - parameter calendar: <#calendar description#>
     - parameter date:     <#date description#>
     
     - returns: <#return value description#>
     */
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return datesWithEvent.contains(calendar.stringFromDate(date))
    }
}

// MARK: - 日程列表
extension ScheduleViewController:UITableViewDataSource,UITableViewDelegate{
    override func viewDidAppear(animated: Bool) {
//        let nowDate = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        let nowString = dateFormatter.stringFromDate(nowDate)
//        let predicate = NSPredicate(format: "Date = %@", nowString)
//        let schedules = realm.objects(Schedule).filter(predicate)
//        //print(schedules)
//        arrSchedule.removeAll()
//        for result in schedules{
//            arrSchedule.append(result)
//        }
//        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonSchedule.count
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /**
     跳转到详细
     - parameter tableView: <#tableView description#>
     - parameter indexPath: <#indexPath description#>
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tmpSchedule.id = jsonSchedule[indexPath.row]["id"] as! String
        tmpSchedule.Title = jsonSchedule[indexPath.row]["title"] as! String
        tmpSchedule.Content = jsonSchedule[indexPath.row]["content"] as! String
        tmpSchedule.Date = jsonSchedule[indexPath.row]["arrangeDate"] as! String
        tmpSchedule.ArrangePerson = jsonSchedule[indexPath.row]["arrangePersonId"] as! String
        self.performSegueWithIdentifier("showScheduleDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleCell", forIndexPath: indexPath)
            let label = cell.viewWithTag(1) as! UILabel
            label.text = jsonSchedule[indexPath.row]["title"] as? String
        return cell
    }
    
    func showAddWin()->Void{
        self.performSegueWithIdentifier("addSchedule", sender: self)
    }
    
    /**
     给segue传递数据
     - parameter segue:  <#segue description#>
     - parameter sender: <#sender description#>
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addSchedule"){
            let nvc = segue.destinationViewController as! UINavigationController //使用segue
            let vc = nvc.topViewController as! AddScheduleViewController
            vc.schedule.Date = self.calendar.stringFromDate(self.calendar.selectedDate)
            vc.action = "add"
        }
        if(segue.identifier == "showScheduleDetail"){
            let vc = segue.destinationViewController as! ScheduleDetailViewController //使用segue
            vc.schedule=tmpSchedule
        }
    }
}






































