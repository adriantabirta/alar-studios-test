//
//  MapPoint.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation
import MapKit

class MapPoint: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
