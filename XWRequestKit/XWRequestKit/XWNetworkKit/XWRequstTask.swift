//
//  XWRequstTask.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/23.
//  Copyright © 2018 wangjianshi. All rights reserved.
//

import UIKit
import Alamofire


/// 请求类型
enum XWRequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// response 类型
enum XWResponseSerializerType {
    case http
    case json
}



/// 请求优先级
enum XWRequestPriority{
    case low 
    case normal
    case high
}


typealias XWRequestSuccessBlock = (_ responseData: Any?) -> Void

typealias XWRequestFailureBlock = (_ error: NSError) -> Void

class XWRequstTask: NSObject {
    
    fileprivate var afrequest: Request?
    
    fileprivate var urlRequst: URLRequest?
    
    fileprivate var manager: SessionManager {
        
        get {
            return Alamofire.SessionManager.default
        }
    }
    
    var priority: XWRequestPriority = .normal {
        
        didSet {
            switch priority {
            case .low:
                self.afrequest?.task?.priority = URLSessionTask.lowPriority
            case .normal:
                self.afrequest?.task?.priority = URLSessionTask.defaultPriority
            case .high:
                self.afrequest?.task?.priority = URLSessionTask.highPriority
            }
        }
    }
    
    var timeoutInterval: TimeInterval = 20 {
        
        didSet {
           self.urlRequst?.timeoutInterval = self.timeoutInterval
        
        }
    }
    
    var isCanceled: Bool {
        if afrequest == nil {
            return false
        }
        return afrequest?.task?.state == .canceling
    }
  
    var isExecuting: Bool {
        if afrequest == nil {
            return false
        }
        return afrequest?.task?.state == .running
    }
    
    var taskIdentifier: Int? {
        
        return afrequest?.task?.taskIdentifier
    }
    
    

    init(_ url: String, method: XWRequestMethod = .post, parameters: [String: Any]? = nil, headers: [String: String]? = nil) {
       
        super.init()
        
        guard let urlRequest = getURLRequest(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers) else {
            debugPrint("[network]: build urlRequest error")
            return
        }
        self.urlRequst = urlRequest
        self.urlRequst?.timeoutInterval = self.timeoutInterval
        
        self.afrequest = manager.request(self.urlRequst!).validate()
    }
    
    /// build URLRequest
    private func getURLRequest(_ url: String, method: XWRequestMethod , parameters: [String: Any]? = nil, encoding: ParameterEncoding = Alamofire.URLEncoding.default, headers: HTTPHeaders? = nil) -> URLRequest? {
        var originalRequest: URLRequest?
        do {
            originalRequest = try URLRequest(url: url, method: HTTPMethod(rawValue: method.rawValue)!, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
            return encodedURLRequest
        } catch {
            debugPrint("[network]: \(error.localizedDescription)")
            return originalRequest
        }
    }
    

}

extension XWRequstTask {
    
    //取消请求
    public func cancel() {
        afrequest?.cancel()
    }
    
    //恢复请求
    public func resume() {
        afrequest?.resume()
    }
    
    //暂停请求
    public func suspend() {
        afrequest?.suspend()
    }
    
    public func request(success: XWRequestSuccessBlock?, failure: XWRequestFailureBlock?) {

        if let dataRequest: DataRequest = self.afrequest as? DataRequest {
            
            dataRequest.response { [weak self] (responseData) in
         
                if let data = responseData.data {
                    
                    success?(data)
                }else if let error = responseData.error {
                    failure?(NSError.init(domain: error.localizedDescription, code: -1, userInfo: nil))
                }else{
                    failure?(NSError.init(domain: "请求出错！", code: -1, userInfo: nil))
                }
            }
            dataRequest.resume()
        }
        
    }
}
