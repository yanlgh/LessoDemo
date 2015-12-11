//
//  Customer.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/18.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import Foundation
import RealmSwift

/**
 客户状态
 */
let CustomerStatus:[String]  = [
     "初步沟通",
     "拜访洽谈",
     "确定意向",
     "签约合作",
     "停滞客户",
     "流失客户"
]

/**
 客户级别
 */
let CustomerLevel:[String] = [
    "小型客户",
    "中型客户",
    "大型客户",
    "VIP客户"
]

/// 客户类
public class Customer :Object {
    public var id:String!
    
    public var name:NSString!
    
    public var phone:String!
    
    public var tel:String!
    
    public var email:String!
    
    public var address:String!
    
    public var post:String!
    
    public var customerStatus:Int!
    
    public var customerLevel:Int!
    
    //public var CustomerStatus
    
    /**
     显示首字母
     - returns: <#return value description#>
     */
    func contactInitials() -> String {
        var initials = String()
        if name.length > 0
        {
            initials.appendContentsOf(name.substringToIndex(1))
        }
        return initials
    }
    /*
    func getCustomerStatus()->[String]{
        customerStatus = [String]()
        customerStatus.append("初步沟通")
        customerStatus.append("拜访洽谈")
        customerStatus.append("确定意向")
        customerStatus.append("签约合作")
        customerStatus.append("停滞客户")
        customerStatus.append("流失客户")
        return customerStatus
    }
    */
    
}