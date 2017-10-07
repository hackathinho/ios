//
//  WebService.swift
//  SmartJump
//
//  Created by Boris Chirino on 07/10/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Alamofire

fileprivate let wsurl = "http://smartjump.ovh:5001"


open class WebService {
    
    
    fileprivate static let shared = WebService()
    
    fileprivate var session :SessionManager = {
        let configuration = URLSessionConfiguration.ephemeral
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    
    class func neareststations(params : Dictionary<String, Any>, completion :@escaping (Array<Dictionary<String, Any>>?, Error?) -> Void) {
        shared.session.request(wsurl+"/nearest", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    if let responseContent = response.result.value as? Array<Dictionary<String, Any>> {
                        completion(responseContent  , nil)
                    }else  {
                        completion(nil  , NSError(domain: "APP-JUMP", code: 10, userInfo: [NSLocalizedDescriptionKey:"Failure parsing"])  )
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    
}
