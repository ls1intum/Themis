//
//  LoginVMExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.05.23.
//

import Foundation
import Login

extension LoginViewModel {
    var loginDisabled: Bool {
        username.isEmpty || password.count < 8
    }
}
