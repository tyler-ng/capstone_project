//
//  ContactCell1.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-29.
//

import UIKit

class ContactCell1: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var delegate: OpenEmailComposerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(tapToCallOrOpenEmailApp(sender: )))
        rightLabel.addGestureRecognizer(tapAction)
        rightLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapToCallOrOpenEmailApp(sender: UITapGestureRecognizer) {
        guard let string = rightLabel.text else { return }
        
        if string.isPhoneNumber {
            PhoneCallUtilities.callNumber(phoneNumber: string)
        }
        
        if string.isEmail {
            delegate?.openMailApp(string)
        }
    }
    
}
