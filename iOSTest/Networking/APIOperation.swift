//
//  APIOperation.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation

/// API Operation class that can  execute and cancel a request.
class APIOperation: OperationProtocol {
    typealias Output = OperationResult

    /// The `URLSessionTask` to be executed/
    private var task: URLSessionTask?

    /// Instance conforming to the `RequestProtocol`.
    internal var request: RequestProtocol

    /// Designated initializer.
    /// - Parameter request: Instance conforming to the `RequestProtocol`.
    init(_ request: RequestProtocol) {
        self.request = request
    }

    /// Cancels the operation and the encapsulated task.
    func cancel() {
        task?.cancel()
    }

    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `RequestDispatcherProtocol` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: RequestDispatcherProtocol, completion: @escaping (OperationResult) -> Void) {
        task = requestDispatcher.execute(request: request, completion: { result in
            completion(result)
        })
    }
}
