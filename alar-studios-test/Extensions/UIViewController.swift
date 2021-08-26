//
//  UIViewController.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    init(with dependency:Dependency) {
        let storyboard = (Self.self as StoryboardType.Type).storyboard
        switch Self.instantiateSource {
        case .initial:
            self = storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            self = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
        if self is ViewLoadBeforeInject {
            _ = self.view
        }
        self.inject(dependency)
    }
}

public extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
