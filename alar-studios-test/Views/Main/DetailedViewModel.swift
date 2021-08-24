//
//  DetailedViewModel.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import MapKit
import RxCocoa
import RxSwift

struct DetailedViewModel {
    
    private let location: Location
    private let mapZoomInMeters: Double
    
    init(location: Location, mapZoomInMeters: Double = 1500) {
        self.location = location
        self.mapZoomInMeters = mapZoomInMeters
    }
}

extension DetailedViewModel: ViewModelType {
    
    struct Input {}
    
    struct Output {
        let pins: Driver<[MapPoint]>
        let region: Driver<MKCoordinateRegion>
    }
    
    func transform(input: Input) -> Output {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        let point = MapPoint(title: location.name, subtitle: location.country, coordinate: coordinate)
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: mapZoomInMeters, longitudinalMeters: mapZoomInMeters)
        
        return Output(pins: Driver.just([point]), region: Driver.just(region))
    }
}
