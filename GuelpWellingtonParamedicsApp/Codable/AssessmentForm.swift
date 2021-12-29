//
//  ClientFallRiskForm.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-11.
//

import Foundation

// see https://localhost:5001/InteractiveForms/2
struct AssessmentFormDecodable: Decodable {

    // MARK: - JSON Decodables
    // 1
    let id: Int
    let title: String
    let patientId: String?
    let paramedics: String?
    let date: String?
    let hasScoring: Bool
    let sections: [Section]
    
    // 2
    struct Section: Decodable {
        let name: String
        let questions: [Question]
    }
    
    struct Question: Decodable {
        let id: Int
        let type: String
        let title: String
        let content: Content
        let skippedForScoring: Bool
    }
    
    struct Content: Decodable {
        let items: [Item]
        let description: String?
        let max_score: Int?
    }
    
    struct Item: Decodable {
        let description: String
        let value: Int
    }
    
    // 3
    enum CodingKeys: String, CodingKey {
        case id, title, patientId, paramedics, date, hasScoring, sections
    }
}

struct Answer: Codable {
    let score: String
    let details: String
}
