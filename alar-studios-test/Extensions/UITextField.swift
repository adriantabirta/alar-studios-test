//
//  UITextField.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {
    
    func becomeFirstResponder() -> Binder<Void> {
        return Binder(self.base) { (textField, event) in
            textField.becomeFirstResponder()
        }
    }
}
