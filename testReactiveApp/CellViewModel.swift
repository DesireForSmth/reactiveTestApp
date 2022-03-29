//
//  CellViewModel.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import Foundation
import ReactiveSwift

class CellViewModel: NSObject, CellViewModelProtocol {

    private var cellText: String

    private var properties: ButtonProps

    public init(properties: ButtonProps) {
        self.properties = properties
        self.cellText = properties.state.rawValue
    }

    func getCellTitle() -> String {
        return self.cellText
    }

    func getCellColor() -> UIColor {
        return properties.color
    }
}

protocol CellViewModelProtocol: AnyObject {
    func getCellTitle() -> String
    func getCellColor() -> UIColor
}
