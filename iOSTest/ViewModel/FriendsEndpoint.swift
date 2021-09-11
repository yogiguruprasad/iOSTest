//
//  FriendsEndpoint.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation


/// Books endpoint
enum FriendsEndpoint {
    /// Lists all the books.
    case index
}

extension FriendsEndpoint: RequestProtocol {
    var path: String {
        switch self {
        case .index:
            return "api/"
        }
        
    }

    var method: RequestMethod {
        switch self {
        case .index:
            return .get

        }
    }

    var headers: ReaquestHeaders? {
        return nil
    }

    var parameters: RequestParameters? {
        switch self {
        case .index:
            return ["results":"10"]
        }
    }

    var requestType: RequestType {
        return .data
    }

    var responseType: ResponseType {
        return .json
    }

    var progressHandler: ProgressHandler? {
        get { nil }
        set { }
    }
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "results", value: "10")]
    }
    
}
