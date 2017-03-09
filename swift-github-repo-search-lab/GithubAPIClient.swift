//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositiories(with completion: @escaping ([Any]) -> ()) {
        let url = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (dataResponse) in
            if let JSON = dataResponse.result.value as? [Any] {
                completion(JSON)
            }
        }
    }
    
    class func checkIfRepositoryIsStarred (_ repoName:String, completion: @escaping ((Bool) -> ()) ){
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(repoName)"
        let header = ["Authorization" : "token \(Secrets.tokenID)"]
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate().responseJSON { (dataResponse) in
            guard let statusCode = dataResponse.response?.statusCode else {return}
            if statusCode == 204 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    class func starRepository(named:String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(named)"
        let header = ["Authorization" : "token \(Secrets.tokenID)"]
        Alamofire.request(urlString, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: header).validate().response { (dataResponse) in
            guard let statusCode = dataResponse.response?.statusCode else {return}
            if statusCode == 204 {
     
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    class func unstarRepository(named:String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(named)"
        let header = ["Authorization" : "token \(Secrets.tokenID)"]
        Alamofire.request(urlString, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).validate().response { (dataResponse) in
            guard let statusCode = dataResponse.response?.statusCode else {return}
            if statusCode == 204{
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    
    class func searchForRepo(search: String, completion: @escaping ([String:Any]) -> ()) {
        
        Alamofire.request("https://api.github.com/search/repositories?q=\(search)+language:assembly&sort=stars&order=desc&client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (dataResponse) in
            
            let JSON = dataResponse.result.value as? [String:Any] ?? [:]
            completion(JSON)
            
        }
        
        
    }
}
