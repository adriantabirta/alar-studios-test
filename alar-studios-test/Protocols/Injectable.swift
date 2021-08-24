//
//  Injectable.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

public protocol Injectable {
    
    associatedtype Dependency = Void
    func inject(_ dependency: Dependency)
}

public extension Injectable where Dependency == Void {
    func inject(_ dependency: Dependency) {
        
    }
}
