//
//  ContactInforCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-15.
//

import UIKit
protocol OpenEmailComposerDelegate: AnyObject {
    func openMailApp(_ email: String)
}

class ContactInforCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var delegate: OpenEmailComposerDelegate?
    
    var data: Contact? {
        didSet {
            guard let contact = data else { return }
            var contactItems = [String: String]()
            contactItems["Name:"] = contact.name
            contactItems["Title/Position:"] = contact.title
            contactItems["Phone:"] = contact.phone
            contactItems["Ext:"] = contact.ext
            contactItems["Email:"] = contact.email
            
            for (key, value) in contactItems {
                if value.count > 0 {
                    let view = MyClass.instanceFromNib(nibView: "ContactItemCell") as! ContactItemCell
                    view.keyLabel.text = key
                    view.valueLabel.text = value
                    if key == "Phone:" {
                        let phoneTapAction = UITapGestureRecognizer(target: self, action: #selector(tapToCall(sender:)))
                        view.valueLabel.isUserInteractionEnabled = true
                        view.valueLabel.addGestureRecognizer(phoneTapAction)
                    }
                    
                    if key == "Email:" {
                        let emailTapAction = UITapGestureRecognizer(target: self, action: #selector(tapToOpenEmailComposer(sender:)))
                        view.valueLabel.isUserInteractionEnabled = true
                        view.valueLabel.addGestureRecognizer(emailTapAction)
                    }
                    
                    stackView.addArrangedSubview(view)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func tapToCall(sender: UITapGestureRecognizer) {
        guard let phoneNo = data?.phone else { return }
        PhoneCallUtilities.callNumber(phoneNumber: phoneNo)
    }
    
    @objc func tapToOpenEmailComposer(sender: UITapGestureRecognizer) {
        guard let email = data?.email else { return }
        delegate?.openMailApp(email)
    }
}
