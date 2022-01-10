//
//  FormSubmitCell.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-18.
//

import UIKit

protocol FormSubmitCellDelegate: AnyObject {
    func submitBtnPressed()
}

class FormSubmitCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: FormSubmitCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.backgroundColor = .systemGray3
        submitButton.layer.cornerRadius = 5
        submitButton.isUserInteractionEnabled = false
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        delegate?.submitBtnPressed()
    }
}
