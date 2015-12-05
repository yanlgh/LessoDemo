//
//  Schedule.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/7.
//  Copyright © 2015年 LESSO. All rights reserved.
//


import RealmSwift

class Schedule: Object {
    dynamic var id = ""
    dynamic var Title = ""
    dynamic var Content = ""
    dynamic var Date = ""
    dynamic var ArrangePerson = ""
    dynamic var IsSubmit:Bool = false
}
