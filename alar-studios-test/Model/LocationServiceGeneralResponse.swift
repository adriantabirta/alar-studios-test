//
//  LocationServiceGeneralResponse.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

struct LocationServiceGeneralResponse<D: Decodable>: Decodable {
    
//    "status": "ok",
//    "code": "8315473994"
    
    let status: String
    
    let code: String?
    
    let page: Int?
    
    let data: D?
}
