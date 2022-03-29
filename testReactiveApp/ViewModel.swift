//
//  ViewModel.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import Foundation
import ReactiveSwift

class MainViewModel: NSObject, MainViewModelProtocol {

    var buttonTableProps = [
        ButtonProps(state: .error, color: .red),
        ButtonProps(state: .loading, color: .orange),
        ButtonProps(state: .ready, color: .green)
    ]

    var cellModels: [CellViewModelProtocol] = []

    func generateCellModels() {
        for prop in buttonTableProps {
            self.cellModels.append(CellViewModel(properties: prop))
        }
    }

    func getCellModels() -> [CellViewModelProtocol] {
        return self.cellModels
    }
}

protocol MainViewModelProtocol: AnyObject {
    func getCellModels() -> [CellViewModelProtocol]
    func generateCellModels()
}
