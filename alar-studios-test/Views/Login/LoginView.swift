//
//  ViewController.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

/*
 
 Сделать простое приложение клиент для просмотра онлайн базы данных.
 Общие требования:
 Все должно быть кратко и понятно.
 Цель теста: увидеть, как претендент пишет код и придумывает архитектуру - никаких копи-пейст "стандартных решений"/
 Три экрана:
 При запуске.
 Показывает текстовые поля логин/пароль и кнопку "Войти".
 При нажатии идет к серверу GET http://www.alarstudios.com/test/auth.cgi (параметры запроса: username=XXX, password=XXX), он возвращает JSON.
 Если "status" == "ok", то пропускаем, нет - показываем красиво, что логин/пароль неправильные.
 Сервер выдаст "ok" на "test"/"123" и тогда идем на следующий экран, запоминая "code".
 
 Таблица с данными.
 Данные получаем по GET http://www.alarstudios.com/test/data.cgi (параметры запроса: code=XXX из предыдущего шага, p=N - страница с 1), выдает по 10 элементов.
 
 В приложении - отображается как бесконечная пагинация. Доходим до "низа" списка - подгружаем данные.
 Каждый элемент таблицы должен содержать картинку (выберите любой внешний URL), подгружаемую асинхронно и имя (name из полученных данных).
 При нажатии на элемент, переходим на третий экран.
 По нажатию на элемент на втором экране переходим сюда.
 Показываем все поля и карту с точкой по координатам в полях "lat"/"lon" из JSON.
 Даем возможность вернуться к списку.
 
 
 Всё. Очень просто. На выполнение дается 72 часа. Оцениваем не только сам факт и скорость выполнения, но в гораздо большей степени качество, аккуратность и выбранные решения. Если есть вопросы - пишите!
 Перед отправкой, УБЕДИТЕСЬ, что все работает, как нужно, что учитывает "эффект пользователя". Например, быстрая прокрутка.*/

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
