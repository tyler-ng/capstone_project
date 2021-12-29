//
//  MultipleChoiceQuestion.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

protocol MultipleChoiceQuestionCellDelegate: AnyObject {
    func getAnswerFromMultipleChoiceQuestion(_ answer: String)
}

class MultipleChoiceQuestionCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: MultipleChoiceQuestionCellDelegate?
    
    public var data: Question? {
        didSet {
            let firstItem = Item(description: data!.title, value: 0)
            data?.content.items.insert(firstItem, at: 0)
            let count = data!.content.items.count
            tableViewHeightConstraint?.constant = CGFloat(Double(count) * LayoutConstraints.labelAndCheckRadioCellHeight)
            myTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mainView.backgroundColor = .systemGray3
        
        myTableView.register(UINib(nibName: "QuestionTitleCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.questionTitleCell.rawValue)
        myTableView.register(UINib(nibName: "LabelAndCheckRadioCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue)
        
        myTableView.layer.cornerRadius = 5
        myTableView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.content.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.questionTitleCell.rawValue, for: indexPath) as! QuestionTitleCell
            guard let question = data else { return cell }
            cell.selectionStyle = .none
            let items = question.content.items
            cell.TitleLb.text = items[indexPath.row].description
           
            return cell
        } else {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue, for: indexPath) as! LabelAndCheckRadioCell
            guard let question = data else { return cell }
            cell.selectionStyle = .none
            let items = question.content.items
            let description = items[indexPath.row].description
            cell.answerChoiceLabel.text = description
            if question.answer == description {
                cell.radioImageView.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                cell.radioImageView.image = UIImage(systemName: "circle")
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeightConstraint?.constant = myTableView.contentSize.height
        myTableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tappedCell = tableView.cellForRow(at: indexPath) as? LabelAndCheckRadioCell {
            let answer = tappedCell.answerChoiceLabel.text!
            delegate?.getAnswerFromMultipleChoiceQuestion(answer)
        }
    }
}
