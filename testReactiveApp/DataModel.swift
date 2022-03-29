//
//  DataModel.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import Foundation
import UIKit

enum ButtonState: String {
    case loading = "Change to loading"
    case ready = "Change to ready"
    case error = "Change to error"
}

struct ButtonProps {
    var state: ButtonState
    var color: UIColor
}

