//
//  ViewController.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

class LoginView: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    private weak var coordinator: LoginCoordinator!
    private var viewModel: LoginViewModel!
    private var disposeBag: DisposeBag!
}

extension LoginView: StoryboardInstantiatable {
    
    struct Dependency {
        let coordinator: LoginCoordinator
        let viewModel: LoginViewModel
        let disposeBag: DisposeBag
    }
    
    static var storyboardName: StoryboardName { "Main" }
    
    func inject(_ dependency: Dependency) {
        _ = self.view
        self.coordinator = dependency.coordinator
        self.viewModel = dependency.viewModel
        self.disposeBag = dependency.disposeBag
        
        self.rx.viewWillAppear.map{ _ in }.bind(to: usernameTextField.rx.becomeFirstResponder()).disposed(by: disposeBag)
        
        
        let input = LoginViewModel.Input(username: usernameTextField.rx.text.orEmpty,
                                         password: passwordTextField.rx.text.orEmpty,
                                         didTapLogin: loginButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.showLoadingIndicator.drive(activityIndicator.rx.isHidden).disposed(by: disposeBag)
        output.showLoadingIndicator.map{ !$0 }.drive(loginButton.rx.isHidden).disposed(by: disposeBag)
        output.isLoginButtonEnabled.drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        
        output.onLoginWithSuccess.drive(coordinator.rx.navigateToMainApp).disposed(by: disposeBag)
        output.dismissKeyboard.drive(self.view.rx.endEditing()).disposed(by: disposeBag)
        
    }
}
