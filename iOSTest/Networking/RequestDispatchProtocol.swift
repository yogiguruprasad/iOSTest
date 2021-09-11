//
//  RequestDispatchProtocol.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation

/// The expected result of an API Operation.
enum OperationResult {
    /// JSON reponse.
    case json(result : Any?, _ : HTTPURLResponse?)
    /// A downloaded file with an URL.
    case file(fileURL : URL?, _ : HTTPURLResponse?)
    /// An error.
    case error(errorResponse : Error?, _ : HTTPURLResponse?)
}

/// Protocol to which a request dispatcher must conform to.
protocol RequestDispatcherProtocol {

    /// Required initializer.
    /// - Parameters:
    ///   - environment: Instance conforming to `EnvironmentProtocol` used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol)

    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `RequestProtocol`
    ///   - completion: Completion handler.
    func execute(request: RequestProtocol, completion: @escaping (OperationResult) -> Void) -> URLSessionTask?
}
