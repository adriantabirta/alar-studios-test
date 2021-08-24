//
//  Location.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

struct Location: Decodable {
    
    let id: String
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    var url: String?
    
    init() {
        self.id = ""
        self.name = ""
        self.country = ""
        self.lat = 0
        self.lon = 0
        self.url = ""
    }
    
    init(_ location: Location, url: String) {
        self.id = location.id
        self.name = location.name
        self.country = location.country
        self.lat = location.lat
        self.lon = location.lon
        self.url = url
    }
}
