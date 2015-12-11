//
//  MainViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/11.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit


class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChildViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.tintColor = UIColor.orangeColor()
    }
    
    private func addAllChildViewController(){
        setupOneChildViewController(ProfileViewController(), title: "首页", itemImageName: "tabbar_home", badgeValue: "5")
        setupOneChildViewController(LocationViewController(), title: "日程", itemImageName: "tabbar_home", badgeValue: "10")
    }
    
    private func setupOneChildViewController(viewController:UIViewController,title:String,itemImageName:String,badgeValue:String?){
        viewController.title = title
        viewController.tabBarItem.image = UIImage(named: itemImageName)
        viewController.tabBarItem.selectedImage = UIImage(named: "\(itemImageName)_selected")
        viewController.tabBarItem.badgeValue = badgeValue
        //let nav = MainNavigationController(rootViewController: viewController)
        addChildViewController(viewController)
    }
}
