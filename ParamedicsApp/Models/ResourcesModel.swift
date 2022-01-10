//
//  ResourcesModel.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-15.
//

import Foundation

struct Region {
    let id: Int
    let name: String
    let resources: [Resource]
}

struct Resource {
    let id: Int
    let name: String
    let location: String
    let logo: String
    let websiteURL: String?
    let contacts: [Contact]?
}

struct Contact {
    let id: Int
    let name: String
    let title: String?
    let phone: String?
    let ext: String?
    let fax: String?
    let email: String
}
