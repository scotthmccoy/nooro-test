//
//  Network.swift
//  ANF Code Test
//
//  Created by Scott McCoy on 1/15/25.
//


import Foundation

enum NetworkError: Error, Equatable {
    case invalidUrl(String)
    case dataTaskError(String)
    case invalidResponse
    case badStatusCode(Int)
}


protocol NetworkProtocol: Sendable {
    func requestData(
        urlRequest: URLRequest
    ) async -> Result<Data, NetworkError>
}

// Dependency Injection for URLSession
protocol URLSessionProtocol: Sendable {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {}


final class Network: NetworkProtocol {
    private let session: URLSessionProtocol
    
    init(
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.session = session
    }
    
    func requestData(
        urlRequest: URLRequest
    ) async -> Result<Data, NetworkError> {
        
        AppLog("urlRequest: \(urlRequest)")

        // Get Data
        let urlSessionResult = await Result.asyncCatching {
            try await session.data(for: urlRequest, delegate: nil)
        }

        guard case let .success((data, urlResponse)) = urlSessionResult else {
            return .failure(.dataTaskError("\(urlSessionResult.error!)"))
        }

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return .success(data)
        }
        
        // Handle HTTPURLResponse
        guard (200..<300) ~= httpResponse.statusCode else {
            return .failure(.badStatusCode(httpResponse.statusCode))
        }
        
        return .success(data)
    }
}
