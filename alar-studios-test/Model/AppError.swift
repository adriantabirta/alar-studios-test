//
//  AppError.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation
import UIKit

enum AppError: Error, CustomStringConvertible {
    
    /// User initiated error
    case general(String)
    
    /// Create a error from another
    case selfDescribing(Error)
    
    /// Network errors
    case network(ApiError)
    
    /// Decoder error with class that cannot be decoded
    case unableToDecode(Any.Type)
    
    /// Fow all strange error we will use `unknown`.
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
        case let .general(error):
            return error
        case let .selfDescribing(error):
            return String(describing: error)
        case let .network(apiError):
            return apiError.description
        case let .unableToDecode(classType):
            return "Unable to decode \(classType) from raw data."
        case .unknown:
            return "Something terible happend."
        }
    }
}

extension AppError {
    
    func handle() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oops!", message: self.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
