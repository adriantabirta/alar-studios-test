//
//  UIScrollView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}

