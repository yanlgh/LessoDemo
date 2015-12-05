//
//  LocationViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/11.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class LocationViewController: UIViewController {

    //@IBOutlet weak var btn_Start: UIButton!
    
    @IBOutlet weak var mapView: BMKMapView!
    
    var locationService:BMKLocationService!
   
    var userLocation:BMKUserLocation!
    
    var region:BMKCoordinateRegion!
    
    var signInLocated = SignInLocated()
    
    var arrSignInLocated = NSArray()
    
    var isDataLoaded = false
    
    /// 地理位置编码
    var geocodeSearch: BMKGeoCodeSearch!
    
    let realm = try!Realm()
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var txtAddress: UILabel!
    
    /**
     切换view
     - parameter sender: <#sender description#>
     */
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            view1.hidden = false
            view2.hidden = true
            break
        case 1:
            view1.hidden = true
            view2.hidden = false
            if(!isDataLoaded){
                loadSignedData()
            }
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 5
        let profile = realm.objects(Profile)
        signInLocated.signer = profile[0]["id"] as! String
        locationService = BMKLocationService()
        locationService.startUserLocationService()
        // 地理编码器初始化
        geocodeSearch = BMKGeoCodeSearch()
        geocodeSearch.delegate = self
        initLocate()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
//    func loadSubStaff(){
//        let url = ""
//        Alamofire.request(.GET, <#T##URLString: URLStringConvertible##URLStringConvertible#>)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - view1(百度地图)
extension LocationViewController:BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        mapView.zoomLevel = 16 //地图级别
        locationService.delegate = self
    }
    
    /**
     初始化定位
     - returns: <#return value description#>
     */
    func initLocate() {
        locationService.startUserLocationService()
        mapView.showsUserLocation =  false//先关闭显示的定位图层
        mapView.userTrackingMode = BMKUserTrackingModeNone//设置定位的状态
        mapView.showsUserLocation = true//显示定位图层
        //mapView.scrollEnabled = true//允许用户移动地图
        mapView.updateLocationData(userLocation)//更新当前位置信息，强制刷新定位图层
        //btn_Start.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.clearAllNotice()
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locationService.delegate = nil
    }
    
    func willStartLocatingUser() {
        print("start locate")
    }
    
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
    }
    
    /**
     位置变化
     - parameter userLocation: <#userLocation description#>
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        mapView.centerCoordinate = userLocation.location.coordinate
        let point = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)
        let unGeocodeSearchOption = BMKReverseGeoCodeOption()
        unGeocodeSearchOption.reverseGeoPoint=point
        _ = geocodeSearch.reverseGeoCode(unGeocodeSearchOption)
        //mapView.updateLocationData(self.userLocation)
        signInLocated.latitude = String(userLocation.location.coordinate.latitude)
        signInLocated.longitude = String( userLocation.location.coordinate.longitude)
    }
    
    /**
     获取位置回调
     - parameter searcher: <#searcher description#>
     - parameter result:   <#result description#>
     - parameter error:    <#error description#>
     */
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        if error.rawValue == 0{
            self.txtAddress.text = result.address   //你现在的位置
            let item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            signInLocated.address = result.address
        }
        //print(result.address)
    }
    
    /**
     签到
     - parameter sender: <#sender description#>
     */
    @IBAction func signUpClicked(sender: UIButton) {
        self.pleaseWait()
        
        let url = "http://10.10.6.130:8000/api/AppSignInLocated/Postmst_SignInLocated"
        let params = [
            "signInTime": NSDate(),
            "longitude": signInLocated.longitude,
            "latitude": signInLocated.latitude,
            "address": signInLocated.address,
            "signer": signInLocated.signer
        ]
        Alamofire.request(.POST,url,parameters: params)
            //异步接收
            .responseJSON{ response in
                self.clearAllNotice()
                if let rst = response.result.value{
                    let json = JSON(rst)
                    //print(json)
                    let flag = json["rst"].rawValue
                    if flag as! NSNumber  == 1 {
                        self.noticeSuccess("签到成功", autoClear: true, autoClearTime: 1)
                        self.btnSignUp.setTitle("已签到", forState: UIControlState.Normal)
                        self.btnSignUp.enabled = false
                        self.btnSignUp.backgroundColor = UIColor.lightGrayColor()
                    }
                    else{
                        self.noticeSuccess("签到失败", autoClear: true, autoClearTime: 1)
                    }
                }
        }
    }
    
    func didFailToLocateUserWithError(error: NSError!) {
        print("error")
    }
}

// MARK: - view2签到记录
extension LocationViewController:UITableViewDataSource,UITableViewDelegate{
    
    /**
     加载签到内容
     */
    func loadSignedData(){
        self.pleaseWait()
        let page  = "1"
        let pageCount = "15"
        let url = "http://10.10.6.130:8000/api/AppSignInLocated/GetSignedList/" + self.signInLocated.signer + "?page=" + page + "&pageCount=" + pageCount
        Alamofire.request(.GET,url)
            //异步接收
            .responseJSON{ response in
                self.isDataLoaded = true
                self.clearAllNotice()
                let json = JSON(response.result.value!)
                self.arrSignInLocated = json.arrayObject! as NSArray
                self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath)
        if(arrSignInLocated.count>0){
            let label = cell.viewWithTag(1) as! UILabel
            label.text = arrSignInLocated[indexPath.row]["address"] as? String
        }
        return cell
    }
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSignInLocated.count
    }
}
