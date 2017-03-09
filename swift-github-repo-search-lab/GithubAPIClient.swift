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
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        })
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred (_ repoName: String, completion: @escaping (Bool) -> () ) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(repoName)"
        if let url = URL(string: urlString){
            var urlRequest = URLRequest(url: url)
            
            //add http:// method
            urlRequest.httpMethod = "GET"
            
            //add header
            
            urlRequest.addValue("token \(Secrets.tokenID)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 204 {
                        completion(true)
                        print(response.statusCode)
                    } else {
                        completion(false)
                        print(response.statusCode)
                    }
                }
            })
            task.resume()
            
        }
    }
    
    class func starRepository(named: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(named)"
        if let url = URL(string: urlString){
        var urlRequest = URLRequest(url: url)
        
        //add http:// method
        urlRequest.httpMethod = "PUT"
        
        //add header
        
        urlRequest.addValue("token \(Secrets.tokenID)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    print("repo was starred")
                    completion()
                } else {
                    print("repo was not starred")
                    completion()
                }
            }
            
        })
        dataTask.resume()
    }
    }
    
    class func unstarRepository(named: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(named)"
        if let url = URL(string: urlString){
            var urlRequest = URLRequest(url: url)
            
            //add http:// method
            urlRequest.httpMethod = "DELETE"
            
            //add header
            
            urlRequest.addValue("token \(Secrets.tokenID)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 204 {
                        print("repo was starred")
                        completion()
                    } else {
                        print("repo was not starred")
                        completion()
                    }
                }
                
            })
            dataTask.resume()
        }
    }
    
    class func searchForRepo(search: String, completion: @escaping ([String:Any]) -> ()) {
//        let githubURL: String = "https://api.github.com/search/repositories"
//        let params = ["q":"\(search)+language:assembly", "sort":"stars", "order":"desc", "client_id": "\(Secrets.githubClientID)", "client_secret": "\(Secrets.githubClientSecret)"]
//        
//        
//        
        Alamofire.request("https://api.github.com/search/repositories?q=\(search)+language:assembly&sort=stars&order=desc&client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (dataResponse) in
            
                        //print("data \n \(dataResponse.data)")
                        //print("original request \n \(dataResponse.request)")
                        //print("http url respone \n \(dataResponse.response)")
                        //print("result \n \(dataResponse.result)")
            let JSON = dataResponse.result.value as? [String:Any] ?? [:]
            print("Yay we got to this point!")
            completion(JSON)
            
            //print("----------\(GithubRepository(dictionary: JSON))")
//             let items = JSON["items"] as? [Any] ?? []
//            print("------ \(items)")
//            let repos = GithubRepository(dictionary: items)
//            print(repos)
            
        
            
        }
        

    }
}
