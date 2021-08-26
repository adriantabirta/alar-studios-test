//
//  FeedViewModel.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation
import RxCocoa
import RxSwift
import MapKit

typealias LocationServiceResponse = Observable<Result<LocationServiceGeneralResponse<[Location]>, AppError>>

class FeedViewModel {
    
    private let code: String
    private var locations: BehaviorRelay<[Location]>
    private let page: BehaviorRelay<Int>
    private let isFetchingData: BehaviorRelay<Bool>
    private let provider: NetworkServiceProvider<LocationService>
    private let disposeBag: DisposeBag
    
    
    init(code: String,
         locations: BehaviorRelay<[Location]> = BehaviorRelay<[Location]>(value: []),
         page:BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1),
         isFetchingData: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false),
         provider: NetworkServiceProvider<LocationService> = NetworkServiceProvider<LocationService>(),
         disposeBag: DisposeBag = DisposeBag()) {
        
        
        self.code = code
        self.locations = locations
        self.page = page
        self.isFetchingData = isFetchingData
        self.provider = provider
        self.disposeBag = disposeBag
    }
}

extension FeedViewModel: ViewModelType  {
    
    struct Input {
        let onItemSelected: ControlEvent<IndexPath>
        let onReachedBottom: ControlEvent<Void>
    }
    
    struct Output {
        let rows: Driver<[Location]>
        let isLoading: Driver<Bool>
        let showTableviewPlaceholder: Driver<Bool>
        let presentDetailedView: Driver<Location>
    }
    
    func transform(input: Input) -> Output {
        
        loadData(LocationService.locationsFor(code: code, page: page.value)).drive(locations).disposed(by: disposeBag)
        
        let onLoadModeData = input.onReachedBottom.filter{ !self.isFetchingData.value }
        
        let onNextPageLoaded = onLoadModeData
            .map{ [unowned self] _ in LocationService.locationsFor(code: self.code, page: self.page.value + 1) }
            .flatMap { [unowned self] in self.loadData($0) }
            .share()
        
        onNextPageLoaded.withLatestFrom(page).map{ $0 + 1 }.bind(to: page).disposed(by: disposeBag)
        onNextPageLoaded.map { [unowned self]  in
            var temp = self.locations.value
            temp.append(contentsOf: $0)
            return temp
        }
        .bind(to: locations)
        .disposed(by: disposeBag)
        
        let showTableviewPlaceholder = locations.map{ $0.count == 0 }.asDriver(onErrorJustReturn: false)
        
        let presentDetailedView = input.onItemSelected
            .map { [unowned self] in self.locations.value[$0.row] }
            .asDriver(onErrorJustReturn: Location())
        
        return Output(rows: locations.asDriver(onErrorJustReturn: []),
                      isLoading: isFetchingData.asDriver(),
                      showTableviewPlaceholder: showTableviewPlaceholder,
                      presentDetailedView: presentDetailedView)
    }
    
    
    private func createImageUrlFrom(_ row: Int) -> String {
        return "https://picsum.photos/id/\(row + 10)/100/100.jpg"
    }
    
    private func loadData(_ request: LocationService) -> Driver<[Location]> {
        return Observable.just(request)
            .do(onNext: { [unowned self] (_) in
                self.isFetchingData.accept(true)
            })
            .flatMapLatest { [unowned self] (req) -> LocationServiceResponse in
                self.provider.request(endpoint: req)
            }
            .flatMap({ (result) -> Observable<LocationServiceGeneralResponse<[Location]>> in
                switch result {
                case let .success(data):
                    // Check if requeset response have correct status.
                    // Otherwise we map and error so that retry mechanism can retry.
                    guard data.status == "ok" else { return Observable.error(AppError.unknown) }
                    return .just(data)
                case let .failure(error): return Observable.error(error)
                }
            })
            // Retry here with exponential delay.
            .retry(RepeatBehavior.exponentialDelayed(maxCount: 5, initial: 1, multiplier: 0.5))
            .compactMap { $0.data }
            .map{ [unowned self] in $0.enumerated().map { Location($0.element, url: self.createImageUrlFrom($0.offset)) }}
            .do(onError: { (error) in
                AppError.selfDescribing(error).handle()
            })
            .do(onNext: { [unowned self] (_) in
                self.isFetchingData.accept(false)
            })
            .asDriver(onErrorJustReturn: [])
    }
}




//
//
//Observable<String>.create { (observer) -> Disposable in
//
//    print("make request")
//    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
////                observer.onNext("send data")
//        observer.onError(Err.lastTry)
//    }
//
//    return Disposables.create()
//}
//.retry(RepeatBehavior.exponentialDelayed(maxCount: 5, initial: 1, multiplier: 0.5))
//.do(onNext: { _ in
//    print("tried")
//})
//.do(onError: { error in
//    print("on error \(error.localizedDescription)")
//})
//.subscribe().disposed(by: disposeBag)

