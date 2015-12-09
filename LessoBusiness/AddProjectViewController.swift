//
//  AddProjectViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/12/8.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Eureka

class AddProjectViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        form = Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["基本信息", "四方信息", "供货情况"]
                $0.value = "基本信息"
            }
            +++ Section(){
                $0.tag = "基本信息"
                $0.hidden = "$segments != '基本信息'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< TextRow(){
                $0.title = "Which is your favourite soccer player?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite coach?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite team?"
            }
            
            +++ Section(){
                $0.tag = "基本信息"
                $0.hidden = "$segments != '基本信息'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< TextRow(){
                $0.title = "Which is your favourite soccer player?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite coach?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite team?"
            }
            
            +++ Section(){
                $0.tag = "四方信息"
                $0.hidden = "$segments != '四方信息'"
            }
            <<< TextRow(){
                $0.title = "Which music style do you like most?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite singer?"
            }
            <<< TextRow(){
                $0.title = "How many CDs have you got?"
            }
            
            +++ Section(){
                $0.tag = "供货情况"
                $0.hidden = "$segments != '供货情况'"
            }
            <<< TextRow(){
                $0.title = "Which is your favourite actor?"
            }
            
            <<< TextRow(){
                $0.title = "Which is your favourite film?"
        }

        // Do any additional setup after loading the view.
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
