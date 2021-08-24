//
//  LoginCoordinator.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

class LoginCoordinator: Coordinator, ReactiveCompatible {
    
    var parrentCoordinator: Coordinator?  = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController =  navigationController
    }
    
    func start() {
        let vc = LoginView(with: LoginView.Dependency(coordinator: self, viewModel: LoginViewModel(), disposeBag: DisposeBag()))
        self.navigationController.setViewControllers([vc], animated: false)
        UIApplication.shared.windows.first?.rootViewController = self.navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension Reactive where Base: LoginCoordinator {
    
    var navigateToMainApp: Binder<String> {
        return Binder(self.base) { (coordinator, authCode) in
            MainAppCoordinator(parrentCoordinator: self.base, authCode: authCode).start()
        }
    }
}
