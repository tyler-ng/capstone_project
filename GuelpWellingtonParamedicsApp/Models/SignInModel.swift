//
//  SignInModel.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-04.
//

import Foundation

struct SignInModel {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var isValidEmail: Bool {
        return email.isEmail
    }
    var isValidPassword: Bool {
        return password.count >= 6
    }
}
