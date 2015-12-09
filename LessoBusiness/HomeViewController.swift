//
//  HomeViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/5.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import ImageSlideshow


class HomeViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    var menuArr:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false   //消除ScrollView顶部空白区域
        let btnLogout:UIBarButtonItem=UIBarButtonItem.init(title: "注销", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.navigationItem.setRightBarButtonItem(btnLogout, animated: false)
        self.myCollectionView.delegate=self
        self.myCollectionView.dataSource=self
        self.myCollectionView.backgroundColor=UIColor.whiteColor()
        slideshow.backgroundColor=UIColor.whiteColor()
        slideshow.slideshowInterval=5.0
        slideshow.pageControlPosition = PageControlPosition.InsideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        slideshow.pageControl.pageIndicatorTintColor=UIColor.lightGrayColor()
        slideshow.setImageInputs([
            AFURLSource(urlString: "https://thumbs.dreamstime.com/z/man-surfboard-beautiful-foggy-beach-boy-running-golden-sunrise-daytona-florida-58532550.jpg")!,
            AFURLSource(urlString: "https://thumbs.dreamstime.com/z/woman-putting-mask-her-face-black-cloak-sitting-ground-58291716.jpg")!
            ])
        loadMenu()
    }

    func logout(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - 九宫格菜单
extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func loadMenu(){
        let realm = try!Realm()
        let profile = realm.objects(Profile)
        let id = profile[0]["id"] as! String
        let url = "http://10.10.6.130:8000/api/AppAccount/GetModuleList?guid=" + id
        Alamofire.request(.GET, url )
            //异步接收
            .responseJSON{
                response in
                var json = JSON(response.result.value!)
                self.menuArr = json["rows"].arrayObject! as NSArray
                self.myCollectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:AnyObject  = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath)
        if( menuArr != nil){
            let image = cell.viewWithTag(1) as! UIImageView
            image.image = UIImage(named: menuArr[indexPath.row]["imageName"] as! String)
            let label = cell.viewWithTag(2) as! UILabel
            label.text = menuArr[indexPath.row]["name"] as? String
        }
        return cell as! UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(menuArr != nil){
            return menuArr.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 8){
            self.notice("开发中...", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            return
        }
        self.performSegueWithIdentifier(menuArr[indexPath.row]["imageName"] as! String, sender: self)
    }
}
