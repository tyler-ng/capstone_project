//
//  YesOrNoQuestionCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

protocol YesNoQuestionCellDelegate: AnyObject {
    func theYesCellWasTapped(_ answer: String, _ index: Int)
    func theNoCellWasTapped(_ answer: String, _ index: Int)
}

class YesNoQuestionCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: YesNoQuestionCellDelegate?
    
    public var data: Question? {
        didSet {
            let firstItem = Item(description: data!.title, value: 0)
            let yesItem = Item(description: "Yes", value: 0)
            let noItem = Item(description: "No", value: 0)
            data?.content.items = [firstItem, yesItem, noItem]
            let count = data!.content.items.count
            tableViewHeightConstraint?.constant = CGFloat(Double(count) * LayoutConstraints.labelAndCheckRadioCellHeight)

            myTableView.reloadData()
        }
    }
    
    public var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mainView.backgroundColor = .systemGray3
        
        myTableView.register(UINib(nibName: "LabelAndCheckRadioCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue)
        myTableView.register(UINib(nibName: "QuestionTitleCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.questionTitleCell.rawValue)
        
        myTableView.layer.cornerRadius = 5
        myTableView.layer.masksToBounds = true
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
            } else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.LabelAndCheckRadioCell.rawValue, for: indexPath) as! LabelAndCheckRadioCell
                guard let question = data else {
                    return cell
                }
                
                let items = question.content.items
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeightConstraint?.constant = myTableView.contentSize.height
        myTableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? LabelAndCheckRadioCell
        guard let cell = cell,
              let index = index,
              let answer = cell.answerChoiceLabel.text
        else { return }
        let row = indexPath.row
        if row == 1 {
            delegate?.theYesCellWasTapped(answer, index)
        } else if row == 2 {
            delegate?.theNoCellWasTapped(answer, index)
        }
    }
}

