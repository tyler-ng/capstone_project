//
//  FillUpQuestionCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

protocol FillUpQuestionCellDelegate: AnyObject {
    func getAnswerFromFillUpQuestionCell(answer: String)
}

class FillUpQuestionCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    
    weak var delegate: FillUpQuestionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = .systemGray3
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        scoreTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.getAnswerFromFillUpQuestionCell(answer: textField.text!)
        scoreTextField.resignFirstResponder()
        return true
    }
}
