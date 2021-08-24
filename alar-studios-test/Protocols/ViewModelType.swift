//
//  ViewModelType.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
