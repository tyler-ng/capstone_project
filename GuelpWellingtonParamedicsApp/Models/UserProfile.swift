//
//  UserProfile.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-03.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let role: String
    
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
}
