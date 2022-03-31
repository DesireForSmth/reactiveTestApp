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

    private var spawnCount = 5
    var alphabetString = "abcdefghijklmnopqrstuvwxyz"

    var shouldUpdateTable: MutableProperty<Bool> = MutableProperty(false)

    var filterSignalObserver: Signal<String, Never>.Observer?

    var lastSearchRequest: String = ""

    var filterSignal: Signal<String, Never>? {
        didSet {
            guard let observer = self.filterSignalObserver else { return }
            filterSignal?.observe(observer)
        }
    }

    private var needsUpdateModelsCollection = MutableProperty(false)

    override init() {
        super.init()
        self.filterSignalObserver = Signal<String, Never>.Observer(value: { [ weak self ] value in
            guard let self = self else { return }
            let lowercaseValue = value.localizedLowercase
            self.lastSearchRequest = lowercaseValue
            self.filterCells(with: lowercaseValue)
        })
        self.needsUpdateModelsCollection.producer.skipRepeats().startWithValues({ [ weak self ] value in
            if value {
                guard let self = self else { return }
                self.generateCellModels()
                self.filterCells(with: self.lastSearchRequest)
                self.needsUpdateModelsCollection.value = false
            }
        })
        self.needsUpdateModelsCollection.value = true
    }

    var buttonTableProps = [
        ButtonProps(state: .error, title: "a"),
        ButtonProps(state: .loading, title: "ab"),
        ButtonProps(state: .ready, title: "abc")
    ]

    var mutableCellCollection: MutableProperty<[CellViewModelProtocol]> = MutableProperty([])
    var mutableDisplayedCollection: MutableProperty<[CellViewModelProtocol]> = MutableProperty([])

    var cellModels: [CellViewModel] = []

    func generateCellModels() {
        for prop in self.buttonTableProps.suffix(self.spawnCount) {
            self.mutableCellCollection.value.append(CellViewModel(properties: prop))
        }
//        self.mutableDisplayedCollection.value.append(contentsOf: self.mutableCellCollection.value)
    }

    func getCellModels() -> [CellViewModelProtocol] {
        return self.mutableDisplayedCollection.value
    }

    func filterCells(with string: String) {
        self.mutableDisplayedCollection.value.removeAll()
        if string.isEmpty {
            self.mutableDisplayedCollection.value.append(contentsOf: self.mutableCellCollection.value)
        }
        else {
            var cellModelsToShow = [CellViewModelProtocol]()
            for model in self.mutableCellCollection.value {
                if model.getCellTitle().hasPrefix(string) {
                    cellModelsToShow.append(model)
                }
            }
            self.mutableDisplayedCollection.value.append(contentsOf: cellModelsToShow)
        }
    }

    private func generateRandomTableProps() -> ButtonProps {
        let title = String(self.alphabetString.prefix(self.buttonTableProps.count % 26 + 1))
        let props = ButtonProps(state: ButtonState.allCases.randomElement() ?? .error, title: title)
//        self.mutableCellCollection.value.append(CellViewModel(properties: props))
        return props
    }

    func generateNewCellModels() {
        print("call generate")
        for _ in 0...(self.spawnCount - 1) {
            self.buttonTableProps.append(generateRandomTableProps())
        }
        self.needsUpdateModelsCollection.value = true
    }
}

protocol MainViewModelProtocol: AnyObject {
    func getCellModels() -> [CellViewModelProtocol]
    func generateCellModels()
    func generateNewCellModels()
    var filterSignal: Signal<String, Never>? { get set }
    var mutableCellCollection: MutableProperty<[CellViewModelProtocol]> { get set }
    var mutableDisplayedCollection: MutableProperty<[CellViewModelProtocol]> { get set }
}
