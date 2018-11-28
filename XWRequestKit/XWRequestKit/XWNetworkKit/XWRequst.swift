//
//  XWRequst.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/23.
//  Copyright © 2018 wangjianshi. All rights reserved.
//

import UIKit

class XWRequst: NSObject {
    
    /// request params
    var params: [String: Any]?
    
    var isCanceled: Bool {
        if requestTask == nil {
            return false
        }
        return requestTask!.isCanceled
    }

    var isExecuting: Bool {
        if self.requestTask == nil {
            return false
        }
        return self.requestTask!.isExecuting
    }
    
    var requestTask: XWRequstTask?
    
    fileprivate var successCallback: XWRequestSuccessBlock?
    
    fileprivate var failureCallback: XWRequestFailureBlock?
    
    
    override init() {
    }
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    //MARK: - 子类可继承实现
    
    /// URL of server, if nil use network config baseUrl
    public func baseUrl() -> String{
        return ""
    }
    
    /// URL of request route
    public func requestUrl() -> String{
        return ""
    }
    
    /// request timeout interval, defalut setting in NetworkConfig
    public func requestTimeoutInterval() -> TimeInterval {
        return 20
    }
    
    /// request params
    public func requestParams() -> [String: Any]? {
        return params
    }
    
    /// request method
    public func requestMethod() -> XWRequestMethod {
        return .get
    }
    
    /// request Priority
    public func requestPriority() -> XWRequestPriority {
        return .normal
    }
    
    /// response serializer type
    public func responseSerializerType() -> XWResponseSerializerType {
        return .json
    }
    
    /// request header fields
    public func requsetHeaderFields() -> [String: String]?{
        return nil
    }
    
    /// checkout status code
    func statusCodeValidator(responseCode: Int?) -> Bool{
        let statusCode = responseCode ?? -1
        return statusCode == 200
    }
    
    /// modify json converto model
    func modifyRequestFinishDataWithResult(json: Any?) -> Any? {
        return json
    }
    
    func modifyRequestFinishDataWithError(error: NSError) -> NSError {
        return error
    }

}

//MARK: - request
extension XWRequst {
    
    func request(_ params: [String: Any]? = nil, success: XWRequestSuccessBlock?, failure: XWRequestFailureBlock?) {
        
        if let param = params {
            self.params = param
        }
        self.successCallback = success
        self.failureCallback = failure
        XWRequestManager.share.request(self, success: {[weak self] (response) in
            
            self?.successCallback?(response)
            XWRequestManager.share.removeReuqestRecord(with: self?.requestTask?.taskIdentifier)
        }) {[weak self] (error) in
            
            self?.failureCallback?(error)
            XWRequestManager.share.removeReuqestRecord(with: self?.requestTask?.taskIdentifier)
        }
        
        
    }
    
    //cancel request
    public func cancel() {
        self.requestTask?.cancel()
        self.successCallback = nil
        self.failureCallback = nil
        XWRequestManager.share.removeReuqestRecord(with: self.requestTask?.taskIdentifier)
    }
    
    //resume request
    public func resume() {
        self.requestTask?.resume()
    }
    
    //suspend request
    public func suspend() {
        self.requestTask?.suspend()
    }
    
}
