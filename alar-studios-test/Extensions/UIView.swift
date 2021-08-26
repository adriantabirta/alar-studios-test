//
//  UIView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension Reactive where Base: UIView {
    
    func endEditing() -> Binder<Void> {
        return Binder(self.base) { (view, event) in
            DispatchQueue.main.async {
                view.endEditing(true)
            }
        }
    }
}
