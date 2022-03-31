//
//  ViewModel.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class MainViewModel: NSObject, MainViewModelProtocol {

    var alphabetString = "abcdefghijklmnopqrstuvwxyz"

    var shouldUpdateTable: MutableProperty<Bool> = MutableProperty(false)

    var buttonTableProps = [
        ButtonProps(state: .error, title: "a"),
        ButtonProps(state: .loading, title: "ab"),
        ButtonProps(state: .ready, title: "abc")
    ]

    var mutableCellCollection: MutableProperty<[CellViewModel]> = MutableProperty([])

    var cellModels: [CellViewModel] = []

    func generateCellModels() {
        for prop in buttonTableProps {
            self.mutableCellCollection.value.append(CellViewModel(properties: prop))
        }
    }

    func getCellModels() -> [CellViewModelProtocol] {
        return self.mutableCellCollection.value
    }

    private func generateRandomTableProps() -> ButtonProps {
        let title = String(self.alphabetString.prefix(self.buttonTableProps.count % 26 + 1))
        let props = ButtonProps(state: ButtonState.allCases.randomElement() ?? .error, title: title)
        self.mutableCellCollection.value.append(CellViewModel(properties: props))
        return props
    }

    func generateNewCellModels() {
        print("call generate")
        let count = 5
        for _ in 0...(count - 1) {
            self.buttonTableProps.append(generateRandomTableProps())
        }
    }
}

protocol MainViewModelProtocol: AnyObject {
    func getCellModels() -> [CellViewModelProtocol]
    func generateCellModels()
    func generateNewCellModels()
    var mutableCellCollection: MutableProperty<[CellViewModel]> { get set }
}
