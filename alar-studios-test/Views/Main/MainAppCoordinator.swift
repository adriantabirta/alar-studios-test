//
//  MainAppCoordinator.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

class MainAppCoordinator: Coordinator, ReactiveCompatible {
    
    internal var parrentCoordinator: Coordinator?
    
    internal var navigationController: UINavigationController
    
    internal var childCoordinators = [Coordinator]()
    
    private var authCode: String
    
    init(parrentCoordinator: Coordinator,
         navigationController: UINavigationController = UINavigationController(rootViewController: UIViewController()),
         authCode: String) {
        self.parrentCoordinator = parrentCoordinator
        self.navigationController = navigationController
        self.authCode = authCode
        self.navigationController.title = "Feed"
    }
    
    func start() {
        let dc = FeedView.Dependency(coordinator: self, viewModel: FeedViewModel(code: authCode), disposeBag: DisposeBag())
        let vc = FeedView(with: dc)
        self.navigationController.setViewControllers([vc], animated: true)
        UIApplication.shared.windows.first?.rootViewController = self.navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension Reactive where Base: MainAppCoordinator {
    
    var navigateToDetailScreen: Binder<Location> {
        return Binder(self.base) { (coordinator, location) in
            let di = DetailedView.Dependency(viewModel: DetailedViewModel(location: location), disposeBag: DisposeBag())
            let vc = DetailedView(with: di)
            self.base.navigationController.pushViewController(vc, animated: true)
        }
    }
}
