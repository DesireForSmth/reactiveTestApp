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

    var shouldUpdateTable: MutableProperty<Bool> = MutableProperty(false)

    var buttonTableProps = [
        ButtonProps(state: .error),
        ButtonProps(state: .loading),
        ButtonProps(state: .ready)
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
        let props = ButtonProps(state: ButtonState.allCases.randomElement() ?? .error)
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
//    var isLoading: Property<Bool> { get }
    func getCellModels() -> [CellViewModelProtocol]
    func generateCellModels()
    func generateNewCellModels()
    var mutableCellCollection: MutableProperty<[CellViewModel]> { get set }
//    var modelsCountSignalProducerGenerator: MutableProperty<Int> { get set }
}
