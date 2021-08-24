//
//  DetailedView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import MapKit
import RxMKMapView
import RxCocoa
import RxSwift

class DetailedView: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    private var viewModel: DetailedViewModel!
    private var disposeBag: DisposeBag!
}

extension DetailedView: StoryboardInstantiatable {
    
    struct Dependency {
        let viewModel: DetailedViewModel
        let disposeBag: DisposeBag
    }
    
    static var storyboardName: StoryboardName { "Main" }
    
    
    func inject(_ dependency: Dependency) {
        _ = self.view
        
        self.title = "Details"
        self.viewModel = dependency.viewModel
        self.disposeBag = dependency.disposeBag
        
        
        let output = self.viewModel.transform(input: DetailedViewModel.Input())
        output.pins.drive(map.rx.annotations).disposed(by: disposeBag)
        output.region.drive(map.rx.region).disposed(by: disposeBag)
    }
}
