//
//  LoginViewController.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/4.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtUname: UITextField!
    
    @IBOutlet weak var txtUpwd: UITextField!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var loginContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUname.delegate=self
        txtUpwd.delegate=self
        btnLogin.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func endEditing(sender: AnyObject) {
        view.endEditing(true)
        //moveBackLoginContentViews()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func onLogin(sender: AnyObject) {
        loadingView.startAnimating()
        let params = [
            "uid":txtUname.text! as String,
            "upwd":txtUpwd.text! as String
        ]
        //self.performSegueWithIdentifier("Login", sender: self)
        Alamofire.request(.POST, "http://10.10.6.130:8000/api/AppAccount/Login", parameters: params)
            //异步接收
            .responseJSON{ response in
                self.loadingView.stopAnimating()
                if let rst=response.result.value{
                    let json = JSON(rst)
                    //print(json["total"])
                    if json["total"] <= 0 {
                        let errorView=UIAlertController(title: "错误", message: "用户名或密码错误", preferredStyle: UIAlertControllerStyle.Alert)
                        errorView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorView, animated: true, completion: nil)
                        self.loadingView.stopAnimating()
                    }else if(json["total"] > 0){
                        let userInfo = JSON(json["rows"].object)
                        //print(userInfo)
                        let profile = Profile()
                        profile.id = String(userInfo["ID"])
                        profile.name = String(userInfo["Name"])
                        let realm = try!Realm()
                        try! realm.write{
                            realm.delete(realm.objects(Profile))
                            realm.add(profile)
                        }
                        //print(profile)
                        self.performSegueWithIdentifier("Login", sender: self)
                    }else{
                        let errorView=UIAlertController(title: "错误", message: "登陆异常", preferredStyle: UIAlertControllerStyle.Alert)
                        errorView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorView, animated: true, completion: nil)
                    }
                }
        }
    }


}



