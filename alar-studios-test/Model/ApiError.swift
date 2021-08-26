//
//  ApiError.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

enum ApiError: Error, CustomStringConvertible {
    
    /// Errors with status code `400` that should be handled and maybe show to user.
    case generalError(code: Int, message: String)
    
    /// Handle URLSession error on dataTask
    case requestFailed(errorMessage: Error)
    
    
    /// Smth bad happend on the way
    case unknown
    
    init?(_ error: Error) {
        switch error.localizedDescription {
        // todo: handle here all catched errors
        default:
            self = .unknown
        }
    }
    
    var description: String {
        
        switch self {
        case .generalError(let code, let message):
            return "Http response code: \(code) with message: \(message)"//"ApiError(code:\(code), message: \(message))"
            
        case let .requestFailed(errorMessage):
            return "Network request failed with message: \(errorMessage.localizedDescription)"
            
        case .unknown:
            return "ApiError - Something bad happend."
            
        }
    }
}
