//
//  LabelAndInputCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-18.
//

import UIKit

protocol LabelAndInputCellDelegate: AnyObject {
    func passingPatientIdToParentView(_ patientId: String, cell: LabelAndInputCell)
}

class LabelAndInputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var labelAndInputCellHeight: NSLayoutConstraint!
    
    @IBOutlet weak var invalidPatientIdText: UILabel!
    
    weak var delegate: LabelAndInputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        invalidPatientIdText.isHidden = true
        inputTextField.delegate = self
        labelAndInputCellHeight?.constant = CGFloat(LayoutConstraints.labelAndInputCellHeight)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.passingPatientIdToParentView(textField.text!, cell: self)
        inputTextField.resignFirstResponder()
        return true
    }
    
}
