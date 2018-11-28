//
//  ViewController.swift
//  XWRequestKit
//
//  Created by 王剑石 on 2018/11/28.
//  Copyright © 2018 wangjianshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func request() {
        
        let api: XWTestApi = XWTestApi()
        api.request(success: { (data) in
            
            print("success")
        }) { (error) in
            
            print("failure")
        }

        
        
    }

    @IBAction func TapRequestBtn(_ sender: UIButton) {
        
        request()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

