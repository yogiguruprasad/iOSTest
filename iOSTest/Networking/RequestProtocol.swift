//
//  RequestProtocol.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation

/// The request type that matches the URLSessionTask types.
enum RequestType {
    /// Will translate to a URLSessionDataTask.
    case data
    /// Will translate to a URLSessionDownloadTask.
    case download
    /// Will translate to a URLSessionUploadTask.
    case upload
}

/// The expected remote response type.
enum ResponseType {
    /// Used when the expected response is a JSON payload.
    case json
    /// Used when the expected response is a file.
    case file
}

/// HTTP request methods.
enum RequestMethod: String {
    /// HTTP GET
    case get = "GET"
    /// HTTP POST
    case post = "POST"
    /// HTTP PUT
    case put = "PUT"
    /// HTTP PATCH
    case patch = "PATCH"
    /// HTTP DELETE
    case delete = "DELETE"
}
/// Type alias used for HTTP request headers.
typealias ReaquestHeaders = [String: String]
/// Type alias used for HTTP request parameters. Used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
typealias RequestParameters = [String : Any?]
/// Type alias used for the HTTP request download/upload progress.
typealias ProgressHandler = (Float) -> Void

/// Protocol to which the HTTP requests must conform.
protocol RequestProtocol {

    /// The path that will be appended to API's base URL.
    var path: String { get }

    /// The HTTP method.
    var method: RequestMethod { get }

    /// The HTTP headers/
    var headers: ReaquestHeaders? { get }

    /// The request parameters used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
    var parameters: RequestParameters? { get }

    /// The request type.
    var requestType: RequestType { get }

    /// The expected response type.
    var responseType: ResponseType { get }

    /// Upload/download progress handler.
    var progressHandler: ProgressHandler? { get set }
}
extension RequestProtocol {

    /// Creates a URLRequest from this instance.
    /// - Parameter environment: The environment against which the `URLRequest` must be constructed.
    /// - Returns: An optional `URLRequest`.
    public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
        // Create the base URL.
        guard let url = url(with: environment.baseURL) else {
            return nil
        }
        // Create a request with that URL.
        var request = URLRequest(url: url)

        // Append all related properties.
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonBody

        return request
    }

    /// Creates a URL with the given base URL.
    /// - Parameter baseURL: The base URL string.
    /// - Returns: An optional `URL`.
    private func url(with baseURL: String) -> URL? {
        // Create a URLComponents instance to compose the url.
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        // Add the request path to the existing base URL path
        urlComponents.path = urlComponents.path + path
        // Add query items to the request URL
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }

    /// Returns the URLRequest `URLQueryItem`
    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard method == .get, let parameters = parameters else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    /// Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        // The body data should be used for POST, PUT and PATCH only
        guard [.post, .put, .patch].contains(method), let parameters = parameters else {
            return nil
        }
        // Convert parameters to JSON data
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
}
