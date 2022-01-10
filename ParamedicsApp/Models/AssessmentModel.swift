//
//  InteractiveFormModel.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-15.
//

import Foundation

//MARK: Common models
struct FormMetaData {
    let title: String
    var value: String?
}

struct SubmitModel: Codable {
    let patientID: String
    let totalScore: Int
    let interactiveFormId: Int
    let assessmentDate: String
    let questionResults: [SubmitQuestion]
}

struct SubmitQuestion: Codable {
    let questionId: Int
    let answer: String
 
}

//MARK: for assessment form folders
struct AssessmentFolderModel {
    let id: Int
    let title: String
    let forms: [FormModel]
}

struct FormModel {
    let id: Int
    let title: String
}

//MARK: Models for all assessment form
struct AssessmentForm {
    let id: Int
    let title: String
    let patientId: String?
    let paramedics: String
    let date: String
    let hasScoring: Bool
    var sections: [Section]
    
    init(id: Int, title: String, paramedics: String, date: String, hasScoring: Bool, sections: [Section]) {
        self.id = id
        self.title = title
        self.hasScoring = hasScoring
        self.sections = sections
        self.patientId = nil
        self.paramedics = paramedics
        self.date = date
    }
}

struct Section {
    let name: String
    var questions: [Question]
}

struct Question {
    var id: Int
    var type: String
    var title: String
    var content: Content
    var answer: String?
}

struct Content {
    var items: [Item]
    let description: String?
    let max_score: Int?
}

struct Item {
    let description: String
    let value: Int
}
