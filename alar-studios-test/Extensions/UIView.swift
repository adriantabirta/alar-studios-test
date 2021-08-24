//
//  UIView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    
    func endEditing() -> Binder<Void> {
        return Binder(self.base) { (view, event) in
            DispatchQueue.main.async {
                view.endEditing(true)
            }
        }
    }
}
