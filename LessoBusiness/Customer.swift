//
//  Customer.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/18.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import Foundation

/**
 客户状态
 */
public enum CustomerStatus{
    case 初步沟通
    case 拜访洽谈
    case 确定意向
    case 签约合作
    case 停滞客户
    case 流失客户
}

/**
 客户级别
 */
public enum CustomerLevel{
    case 小型客户
    case 中型客户
    case 大型客户
    case VIP客户
}

/// 客户类
public class Customer : NSObject{
    public var id:String!
    
    public var name:NSString!
    
    public var tel:String!
    
    public var email:String!
    
    public var address:String!
    
    public var post:String!
    
    public var customerStatus:CustomerStatus!
    
    public var customerLevel:CustomerLevel!
    
    
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
    
    
}