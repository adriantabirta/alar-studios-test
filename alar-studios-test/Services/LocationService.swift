//
//  LocationService.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

enum LocationService: NetworkService {
    case login(username: String, password: String)
    case locationsFor(code: String, page: Int = 1)
}

extension LocationService {
    
    var headers: [String : Any] {
        return [ "Content-Type": "application/json"]
    }
    
    var method: ServiceMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case let .login(username, password):
            return "/auth.cgi?username=\(username)&password=\(password)"
        case let .locationsFor(code, page):
            return "/data.cgi?code=\(code)&p=\(page)"
        }
    }
    
    var baseURL: String {
        return "https://www.alarstudios.com/test"
    }
    
    var body: Data? {
        return nil
    }
    
}
