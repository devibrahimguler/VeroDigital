//
//  Services.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI
// It is used to pull data through API.
final class Services {
    private var url : String
    private var token : String
    private var tokenType : String
    private var isRefresh : Bool
    
    init(isRefresh: Bool = false) {
        
        self.url = "https://api.baubuddy.de/index.php/login"
        self.token = "QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz"
        self.tokenType = "Basic"
        self.isRefresh = isRefresh
    }
    
    // Used to log in and retrieve their data.
    func getDataWithApi(completion: @escaping ([Mission])->()) {
        self.postServices(ofType: User.self, url: url, token: token, tokenType: tokenType, isGetData: false) { objects in
            self.url = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
            self.tokenType = objects[0].oauth.token_type
            if self.isRefresh {
                self.token = objects[0].oauth.refresh_token
            } else {
                self.token = objects[0].oauth.access_token
            }
           
            self.postServices(ofType: Mission.self, url: self.url, token: self.token, tokenType: self.tokenType, isGetData: true){ dataObject in
                completion(dataObject)
            }
        }
    }
    
    // Used for generic function to pull data.
    private func postServices<T : Decodable>(ofType: T.Type, url: String, token: String, tokenType: String, isGetData: Bool, objects: @escaping ([T]) -> ())
    where T : DataModel{
        let headers = [
            "Authorization": "\(tokenType) \(token)",
            "Content-Type": "application/json"
        ]
        
        let url = URL(string: url)!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.allHTTPHeaderFields = headers
        
        if isGetData {
            request.httpMethod = "GET"
        } else {
            let parameters = [
                "username": "365",
                "password": "1"
            ]
            
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                print("Error serializing parameters to JSON")
                exit(1)
            }
            
            request.httpMethod = "POST"
            request.httpBody = postData
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                return
            }
            guard let responseData = data else {
                print("No response data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                if isGetData {
                    let json = try decoder.decode([T].self, from: responseData)
                    DispatchQueue.main.async {
                        objects(json)
                    }
                }
                else {
                    let json = try decoder.decode(T.self, from: responseData)
                    objects([json])
                }
                
            } catch {
                print("Error decoding response data: \(error)")
            }
        }
        task.resume()
    }
}
