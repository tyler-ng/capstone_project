//
//  MultipleChoiceWithInputQuestionCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

protocol MultipleChoiceWithInputQuestionCellDelegate: AnyObject {
    func getAnswerFromMultipleChoiceWithInputQuestion(_ answer: String)
    func getAnswerFromMultipleChoiceWithInputQuestion1(_ answer: String)
}

class MultipleChoiceWithInputQuestionCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: MultipleChoiceWithInputQuestionCellDelegate?
    
    public var data: Question? {
        didSet {
            let firstItem = Item(description: data!.title, value: 0)
            data?.content.items.insert(firstItem, at: 0)
            myTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mainView.backgroundColor = .systemGray3
        
        cellsRegister()
        
        myTableView.layer.cornerRadius = 5
        myTableView.layer.masksToBounds = true
    }
    
    func cellsRegister() {
        myTableView.register(UINib(nibName: "QuestionTitleCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.questionTitleCell.rawValue)
        myTableView.register(UINib(nibName: "LabelAndCheckRadioCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue)
        myTableView.register(UINib(nibName: "ChoiceWithInputCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.choiceWithInputCell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.content.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.questionTitleCell.rawValue, for: indexPath) as! QuestionTitleCell
            guard let items = data?.content.items else { return cell }
            cell.selectionStyle = .none
            cell.TitleLb.text = items[indexPath.row].description
            return cell
        } else if let count = data?.content.items.count, indexPath.row == count - 1 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.choiceWithInputCell.rawValue, for: indexPath) as! ChoiceWithInputCell
            guard let question = data, let items = data?.content.items else { return cell }
            cell.selectionStyle = .none
            cell.delegate = self
            let description = items[indexPath.row].description
            
            if question.answer == description {
                cell.radioImageView.image = UIImage(systemName: "checkmark.circle.fill")
                cell.inputTextField.isHidden = false
                cell.inputTextField.isUserInteractionEnabled = true
            } else if question.answer != nil && question.answer != "A walker" && question.answer != "A cane" {
                cell.radioImageView.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                cell.radioImageView.image = UIImage(systemName: "circle")
                cell.inputTextField.isHidden = true
                cell.inputTextField.isUserInteractionEnabled = false
            }

            cell.choiceTitleLabel.text = description
            
            return cell
        } else {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue, for: indexPath) as! LabelAndCheckRadioCell
            guard let question = data, let items = data?.content.items else { return cell }
            cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tappedCell = tableView.cellForRow(at: indexPath) as? LabelAndCheckRadioCell {
            let answer = tappedCell.answerChoiceLabel.text!
            delegate?.getAnswerFromMultipleChoiceWithInputQuestion(answer)
        } else if let tappedCell = tableView.cellForRow(at: indexPath) as? ChoiceWithInputCell {
            let answer = tappedCell.choiceTitleLabel.text!
            delegate?.getAnswerFromMultipleChoiceWithInputQuestion(answer)
        }
        
    }

}

extension MultipleChoiceWithInputQuestionCell: ChoiceWithInputCellDelegate {
    func passOtherAssistiveToParentView(_ answer: String) {
        // get text from another assistive device text field
        delegate?.getAnswerFromMultipleChoiceWithInputQuestion1(answer)
    }
}
