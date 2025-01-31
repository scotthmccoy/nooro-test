//
//  Result.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

// Keystroke saver.
// Allows a function returning Result<Void, Error> to `return .success()`
extension Result where Success == Void {
    public static func success() -> Self { .success(()) }
}

extension Result {
    var shortDescription: String {
        return isSuccessful ? "successful" : "failed"
    }
    
    public var isSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    public var error: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }

    public func getSuccess (
        failureHandler: ((Failure) -> ())? = nil
    ) -> Success? {
        switch self {
        case .success(let success):
            return success
        case .failure(let failure):
            failureHandler?(failure)
            return nil
        }
    }
    
    @discardableResult
    func getSuccessOrLogError(
        _ message: String = "Error: ",
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function
    ) -> Success? {
        switch self {
        case .success(let value):
            return value

        case .failure(let error):
            AppLog("\(message): \(error)", file: file, line: line, column: column, function: function)
            return nil
        }
    }
}

// Note: This must be `== any Error` because errors caught in Swift catch blocks are of type Error,
// instead of a concrete type implementing Error. Inelegant, yes, but it does remind us why we prefer Result over try/catch:
// we can get concretely typed errors.
extension Result where Failure == any Error {
    /*
        Async version of init(catching: () throws -> Success)
        Usage:
     
        Task {
            await Result.asyncCatching() {
                try await getInt()
            }.mapError { error in
                ConcreteError.wrap(error)
            }
        }
    */
    @available(iOS 13, *)
    static func asyncCatching(
        body: () async throws -> Success
    ) async -> Self {
        do {
            return Self.success(try await body())
        } catch {
            return .failure(error)
        }
    }
}



extension Result {
    func asyncFlatMap<NewSuccess>(_ transform: (Success) async -> Result<NewSuccess, Failure>) async -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let success):
            return await transform(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
