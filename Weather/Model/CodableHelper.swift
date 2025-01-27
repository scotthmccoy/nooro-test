//
//  CodableHelper.swift
//
//  Created by Scott McCoy on 9/26/24.
//


import Foundation

// Stubbable Wrapper for JSONEncoder/JSONDecoder
protocol CodableHelperProtocol: Sendable {
    func encode <T: Encodable>(
        value: T
    ) -> Result<Data, CodableHelperError>
    
    func decode<T: Decodable>(
        type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    ) -> Result<T, CodableHelperError>
}

// MARK: Default Args
// Add default args for keyDecodingStrategy and dateDecodingStrategy
extension CodableHelperProtocol {
    func decode<T: Decodable>(
        type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) -> Result<T, CodableHelperError> {
        decode(
            type: type,
            from: data,
            keyDecodingStrategy: keyDecodingStrategy,
            dateDecodingStrategy: dateDecodingStrategy
        )
    }
}

// MARK: CodableHelperError
public enum CodableHelperError: Error, CustomStringConvertible, Equatable {
    case message(String)
    case fileSystemError(errorString: String)
    case encodingError(errorString: String)
    case decodingError(errorString: String, jsonString: String)

    public var description: String {
        switch self {
        case .message(let message):
            return "message: \(message)"

        case .fileSystemError(let message):
            return "fileSystemError: \(message)"

        case .encodingError(let errorString):
            return "encodingError: \(errorString)"

        case .decodingError(let errorString, let jsonString):
            return "decodingError: \(errorString), jsonString: \(jsonString)"
        }
    }
}

final class CodableHelper: CodableHelperProtocol {

    // MARK: Data
    public func encode <T: Encodable>(
        value: T
    ) -> Result<Data, CodableHelperError> {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        return Result {
            try encoder.encode(value)
        }.mapError { error in
            return .encodingError(errorString: "\(error)")
        }
    }

    public func decode<T: Decodable>(
        type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) -> Result<T, CodableHelperError> {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        return Result<T, Error> {
            try decoder.decode(type, from: data)
        }.mapError { error in
            let jsonString = data.prettyPrintedJSONString
            return .decodingError(errorString: "\(error)", jsonString: jsonString)
        }
    }
}


// MARK: Data
extension Data {
    public var prettyPrintedJSONString: String {
        guard
            let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
            let jsonData = try? JSONSerialization.data(
                withJSONObject: json,
                options: [.prettyPrinted, .withoutEscapingSlashes]
            ),
            let strPretty = String(data: jsonData, encoding: .utf8) else {
            return "Malformed JSON"
        }

        return strPretty
    }
}
