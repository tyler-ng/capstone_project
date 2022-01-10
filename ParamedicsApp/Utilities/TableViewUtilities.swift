//
//  Commons.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-09.
//

import UIKit

class TableViewUtilities {
    static func tableViewCellRegister(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "AssessmentItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.assessmentFolderItemCell.rawValue)
    }
    
    static func stripOutHtmlTagFromText(_ text: String) -> String {
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    static func findOutAQuestion(sections: [Section], sectionName: String, expectedQuestions: [String]) -> Question? {
        // 1. find a section
        let section = sections.filter {
            $0.name == sectionName
        }.first
        
        guard var section = section else { return nil }
        
        // 2. trimming out title of each question
        section.questions.indices.forEach {
            section.questions[$0].title = section.questions[$0].title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // 4. loop through to get wanted question
        var wantedQuestion: Question?
        
        var hashA = [String: Bool]()
        
        expectedQuestions.forEach {
            hashA[$0] = true
        }
        
        section.questions.forEach {
            if hashA[$0.title] == true {
                wantedQuestion = $0
            }
        }
        
        return wantedQuestion
    }
    
    static func createViewForHeaderInSection(_ tableView: UITableView, _ headerHeight: Double, _ title: String) -> UIView {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(headerHeight)))
        headerView.backgroundColor = .systemYellow

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: Int(headerView.frame.width) - 10, height: Int(headerView.frame.height) - 10)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = title
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black

        headerView.addSubview(label)
        return headerView
    }
    
    static func addShadowToView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.backgroundColor = .systemGray5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    static func generateFormMetaData(_ form: AssessmentForm) -> [FormMetaData] {
        var formMetaData = [FormMetaData]()
        
        let patientIdItem = FormMetaData(title: "Patient Id", value: form.patientId)
        let paramedicsItem = FormMetaData(title: "Paramedics", value: form.paramedics)
        let dateItem = FormMetaData(title: "Date time", value: form.date)
        formMetaData.append(patientIdItem)
        formMetaData.append(paramedicsItem)
        formMetaData.append(dateItem)
        
        return formMetaData
    }
    
    static func generateFormMetaData2(_ form: AssessmentForm) -> [FormMetaData] {
        var formMetaData = [FormMetaData]()
        
        let patientIdItem = FormMetaData(title: "Patient Id", value: form.patientId)
        let paramedicsItem = FormMetaData(title: "Paramedics", value: form.paramedics)
        let dateItem = FormMetaData(title: "Date time", value: form.date)
        formMetaData.append(patientIdItem)
        formMetaData.append(paramedicsItem)
        formMetaData.append(dateItem)
        
        return formMetaData
    }
    
    static func addTextToHeaderSection( text: String, tableView: UITableView, xOffset: CGFloat, yOffset: CGFloat, labelHeight: CGFloat, size: CGFloat) -> UIView {
        let v = UIView()
        v.backgroundColor = .systemYellow
        
        let textLabel = UILabel()
        textLabel.frame = CGRect.init(x: xOffset, y: yOffset, width: tableView.frame.width - xOffset, height: labelHeight)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.font = .systemFont(ofSize: size)
        textLabel.textColor = .black

        v.addSubview(textLabel)
        
        return v
    }
}


