//
//  XWRequestManager.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/23.
//  Copyright © 2018 wangjianshi. All rights reserved.
//

import UIKit


class XWRequestManager: NSObject {
    
     static let share = XWRequestManager()
    
     var requestRecord: [Int: XWRequst] = [:]
    
     let lock = NSLock()
    
    func request(_ request: XWRequst, success: XWRequestSuccessBlock?, failure: XWRequestFailureBlock?) {
        
        let url: String = getRequestUrl(request: request)
        let api: XWRequstTask = XWRequstTask.init(url, method: request.requestMethod(), parameters: request.requestParams(), headers: request.requsetHeaderFields())
        request.requestTask = api
        api.timeoutInterval = request.requestTimeoutInterval()
        api.priority = request.requestPriority()
        api.request(success: { (response) in
            
            success?(response)
        }) {(error) in
            failure?(error)
        }
        addRequestRecord(request: request, identify: api.taskIdentifier)
        api.resume()
       
    }
    
    fileprivate func addRequestRecord(request: XWRequst, identify: Int?) {
        
        self.lock.lock()
        defer { self.lock.unlock() }
        if let identifier: Int = identify {
            self.requestRecord[identifier] = request
        }
       
    }
    
    public func removeReuqestRecord(with identify: Int?)  {
        
        DispatchQueue.main.async {
            self.lock.lock()
            defer { self.lock.unlock() }
            if let identifier: Int = identify {
                self.requestRecord[identifier] = nil
            }
        }
        
    }
    
    /// constructed URL of request
    func getRequestUrl(request: XWRequst) -> String {
        let detailUrl = request.requestUrl()
        let temp = URL.init(string: detailUrl)
        
        // temp is valid url
        if temp != nil && temp?.host != nil && temp?.scheme != nil {
            return detailUrl
        }
    
        let baseUrl = request.baseUrl()
        guard var url = URL.init(string: baseUrl) else { return "" }
        if baseUrl.count > 0 && !baseUrl.hasSuffix("/") {
            url = url.appendingPathComponent("")
        }
        guard let urlStr = URL.init(string: detailUrl, relativeTo: url)?.absoluteString else { return "" }
        return urlStr
    }

}
