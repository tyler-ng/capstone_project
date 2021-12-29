//
//  ChoiceWithInputCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-19.
//

import UIKit

protocol ChoiceWithInputCellDelegate: AnyObject {
    func passOtherAssistiveToParentView(_ answer: String)
}

class ChoiceWithInputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var choiceTitleLabel: UILabel!
    @IBOutlet weak var choiceWithInputCellHeight: NSLayoutConstraint!
    
    weak var delegate: ChoiceWithInputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.delegate = self
        inputTextField.isHidden = true
        inputTextField.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // need to do validation for the text field
        let answer = inputTextField.text!
        delegate?.passOtherAssistiveToParentView(answer)
        inputTextField.resignFirstResponder()
        return true
    }
}
