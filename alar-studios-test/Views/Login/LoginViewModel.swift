//
//  LoginViewModel.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    
    private let provider: NetworkServiceProvider<LocationService>
    private let isFetchingData: BehaviorRelay<Bool>
    private let disposeBag: DisposeBag
    
    init(provider: NetworkServiceProvider<LocationService> = NetworkServiceProvider<LocationService>(),
         isFetchingData: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false),
         disposeBag: DisposeBag = DisposeBag()) {
        self.provider = provider
        self.isFetchingData = isFetchingData
        self.disposeBag = disposeBag
    }
}

extension LoginViewModel: ViewModelType {
    
    struct Input {
        let username: ControlProperty<String>
        let password: ControlProperty<String>
        let didTapLogin: ControlEvent<Void>
    }
    
    struct Output {
        let showLoadingIndicator: Driver<Bool>
        let isLoginButtonEnabled: Driver<Bool>
        let dismissKeyboard: Driver<Void>
        let onLoginWithSuccess: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let request = Observable
            .combineLatest(input.didTapLogin.map{ _ in "" }, input.username.asObservable(), input.password.asObservable()) { ($1, $2) }
            .filter{ !$0.0.isEmpty && !$0.1.isEmpty }
            .map{ LocationService.login(username: $0.0, password: $0.1) }
        
        let onResponse = login(request)
        
        let showLoadingIndicator = isFetchingData.map{ !$0 }.asDriver(onErrorJustReturn: false)
        let isLoginButtonEnabled = Observable.combineLatest(input.username.asObservable(), input.password.asObservable()) { ($0, $1) }
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let dismissKeyboard = onResponse.map{ _ in }.asDriver(onErrorJustReturn: ())
        
        let onLoginWithSuccess = onResponse.delay(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
        
        return Output(showLoadingIndicator: showLoadingIndicator,
                      isLoginButtonEnabled: isLoginButtonEnabled,
                      dismissKeyboard: dismissKeyboard,
                      onLoginWithSuccess: onLoginWithSuccess)
    }
    
    private func login(_ request: Observable<LocationService>) -> Observable<(String)> {
        return request
            .do(onNext: { [unowned self] _ in
                self.isFetchingData.accept(true)
            })
            .flatMapLatest { [unowned self] in
                self.provider.request(endpoint: $0) as Observable<Result<LocationServiceGeneralResponse<[String]>, Error>>
            }
            .do(onNext: { [unowned self] _ in
                self.isFetchingData.accept(false)
            })
            .compactMap { try? $0.get() }
            .filter { $0.status == "ok" }
            .compactMap{ $0.code }
    }
}
