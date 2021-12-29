//
//  AssessementForm.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-09.
//

import Foundation

struct AssessementFolder: Decodable {
    // MARK: - JSON Decodables
    // 1
    let id: Int
    let title: String
    let forms: [Form]
    
    // 2
    struct Form: Decodable {
        let id: Int
        let title: String
    }
    
    // 3
    enum CodingKeys: String, CodingKey {
        case id, title
        case forms = "interactiveForms"
    }
}
