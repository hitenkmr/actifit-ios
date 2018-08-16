//
//  API.swift
//  Actifit
//
//  Created by Hitender kumar on 15/08/18.
//

import Foundation

typealias APICompletionHandler = ((_ info : Any?) -> ())?
typealias APIFailureHandler = ((_ error : NSError) -> ())?

public class API : NSObject{
    
    //MARK: Initializers
    
    override init() {
    }
    
    class var sharedInstance : API {
        return API()
    }
 
    //MARK: API callers
    
    func postActvityWith(info : [String : Any], completion : APICompletionHandler, failure : APIFailureHandler) {
        let urlStr = ApiUrls.postActivity
        let url = URL.init(string: urlStr)
        var request = URLRequest.init(url: url!)
        request.addBasicHeaderFields()
        request.appendBodyWith(json: info)
        self.forwardRequest(request: request, httpMethod: HttpMethods.HttpMethod_POST, completion: completion, failure: failure)
    }
    
    func getDailyLeaderboard(completion : APICompletionHandler, failure : APIFailureHandler) {
        let urlStr = ApiUrls.getDailyLeaderboard
        let url = URL.init(string: urlStr)
        var request = URLRequest.init(url: url!)
        request.addBasicHeaderFields()
        self.forwardRequest(request: request, httpMethod: HttpMethods.HttpMethod_POST, completion: completion, failure: failure)
    }
    
    //MARK: Dispatching Request to server
    
    func forwardRequest(request : URLRequest, httpMethod : String, completion : APICompletionHandler, failure : APIFailureHandler) {
        
        var sendRequest:URLRequest = request
        
        sendRequest.httpMethod = httpMethod as String
        //sendRequest.timeoutInterval = 5.0
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: sendRequest, completionHandler: { data, response, error in
            if error == nil{
                if let data = data {
                    #if DEBUG
                    print("Response json Data is \(data)")
                    #endif
                    //use library to extract data from response json
                    if let string = String.init(data: data, encoding: String.Encoding.utf8) {
                        // do {
                        // let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completion!(string)
                        //} catch {
                        //}
                    } else {
                        completion!(nil)
                    }
                } else {
                    completion!(nil)
                }
            } else{
                if failure != nil {
                    failure!(error! as NSError )
                }
            }
            
        })
        task.resume()
    }
}

extension URLRequest {
    mutating func addBasicHeaderFields() {
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // self.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    mutating func appendBodyWith(json : [String : Any]) {
        do {
            self.httpBody = try JSONSerialization.data(withJSONObject: json, options:[])
        } catch _{}
    }
}

