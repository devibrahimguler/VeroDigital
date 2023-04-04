//
//  Services.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI
// It is used to pull data through API.
final class DataPullingService {
    
    // Used for generic function to pull data.
    func postServices<T : Decodable>(ofType: T.Type, url: String, token: String, tokenType: String, isGetData: Bool, completion: @escaping (Result<[T],ConnectionError>)  -> ())
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
                completion(.failure(.dataError))
                exit(1)
            }
            
            request.httpMethod = "POST"
            request.httpBody = postData
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return completion(.failure(.responseError))
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                return completion(.failure(.statusError))
            }
            guard let responseData = data else {
                print("No response data received")
                return completion(.failure(.dataError))
            }
            do {
                let decoder = JSONDecoder()
                if isGetData {
                    let json = try decoder.decode([T].self, from: responseData)
                    DispatchQueue.main.async {
                        completion(.success(json))
                    }
                }
                else {
                    let json = try decoder.decode(T.self, from: responseData)
                    completion(.success([json]))
                }
                
            } catch {
                print("Error decoding response data: \(error)")
                return completion(.failure(.generalError))
            }
        }
        task.resume()
    }
    
    // Error handling.
    enum ConnectionError: Error {
        case responseError
        case statusError
        case dataError
        case generalError
        
    }
}
