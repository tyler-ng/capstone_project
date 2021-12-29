//
//  Resource.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-27.
//

import Foundation

struct RegionDecodable: Decodable {
    let id: Int
    let name: String
    let resources: [ResourceDecodable]
    
    enum CodingKeys: String, CodingKey {
        case id, name, resources
    }
}

struct ResourceDecodable: Decodable {
    let id: Int
    let name: String
    let location: String
    let logo: String
    let websiteURL: String?
    let contacts: [ContactDecodable]?
}

struct ContactDecodable: Decodable {
    let id: Int
    let name: String
    let title: String?
    let phone: String?
    let ext: String?
    let fax: String?
    let email: String
}
