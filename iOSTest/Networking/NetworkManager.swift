//
//  NetworkManager.swift
//  Lovebake
//
//  Created by Guru on 31/08/21.
//

import Foundation


public enum Method: Int {
    case post,get,put,delete
}
extension Method {
    
    var name:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        default:
            return "DELETE"
        }
    }
}


enum ConfigureURL {
    static let BASE_URL         = "https://loyaltyhubapp.com/drawino/webservices/"
    static let LOGIN            = "user/login"
    static let GET_TICKETS      = "tickets/get_tickets"
}


class NetworkManager:NSObject {
    let config = URLSessionConfiguration.default
    var session : URLSession = URLSession.shared
    static func sharedInstance() ->  NetworkManager{
        return NetworkManager()
    }
    
    func makeAPICall<T:Codable>(url: String,modelObject:T.Type, params: [String:Any], method: Method, callback:Callback<T,String>) {
        guard let urlComponents = URL(string: ConfigureURL.BASE_URL + url) else { return }
        print(params)
        var  request = URLRequest(url: urlComponents)
        let postString = NetworkManager.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        request.httpMethod = method.name
        request.addValue("lovebake", forHTTPHeaderField: "APP-USER")
        request.addValue("df014f04b7e13046a2d057c9f2ce3e2b", forHTTPHeaderField: "APP-PWD")
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do{
                        let json = try JSONDecoder().decode(modelObject, from: data)
                       
                        callback.onSuccess(json)
                        
                    }catch let error {
                        
                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                            callback.onFailure(json["message"] as? String ?? json["error"] as? String ?? error.localizedDescription)
                        }else{
                            callback.onFailure(error.localizedDescription)
                        }
                    }
                }else if let response = response as? HTTPURLResponse, 400...499 ~= response.statusCode{
                    print("Api Failed with Response Code:\(response.statusCode)")
                    let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                    print(json)
                    
                    callback.onFailure(json["message"] as? String ?? json["error"] as? String ?? "")
                }else {
                   
                    callback.onFailure("API FAiled")
                }
            }else {
                callback.onFailure(error?.localizedDescription ?? "")
            }
            }.resume()
    }
    static func getPostString(params:[String:Any]) -> String
        {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }
}
