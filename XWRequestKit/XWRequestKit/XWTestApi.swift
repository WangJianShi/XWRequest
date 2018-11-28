//
//  XWTestApi.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/26.
//  Copyright © 2018 wangjianshi. All rights reserved.
//

import UIKit

class XWTestApi: XWRequst {

    override func baseUrl() -> String {
        
        return "http://www.wantu.cn"
    }
    
    override func requestUrl() -> String {
        
        return "/app/v3/home/homeData"
    }
    
    override func requestParams() -> [String : Any]? {
        
        return ["channel": "wantu"]
    }
}
