//
//  ContactModel.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-29.
//

import Foundation

struct Department {
    let name: String
    let contacts: [ParamedicContact]
    let email: String
}

struct ParamedicContact {
    let person: String
    let email: String
    let homePhoneNo: String
    let ext: String
    let workPhoneNo: String
    let personalPhoneNo: String
    let services: [String]
    let availableServices: [String]
}
