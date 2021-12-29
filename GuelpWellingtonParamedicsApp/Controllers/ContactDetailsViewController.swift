//
//  ContactDetailsViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-28.
//

import UIKit
import MessageUI

struct ContactInfor {
    let title: String
    let value: String
}

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var contactRows = [ContactInfor]()
    private var serviceRows = [String]()
    
    
    var contact: ParamedicContact? {
        didSet {
            if let contact = contact {
    
                if contact.email.count > 0 {
                    let item = ContactInfor(title: "Email", value: contact.email)
                    contactRows.append(item)
                }
                
                if contact.homePhoneNo.count > 0 {
                    let item = ContactInfor(title: "Home Phone", value: contact.homePhoneNo)
                    contactRows.append(item)
                }
                
                if contact.ext.count > 0 {
                    if contact.person == "Door Code" {
                        let item = ContactInfor(title: "Door Code", value: contact.ext)
                        contactRows.append(item)
                    } else {
                        let item = ContactInfor(title: "Ext", value: contact.ext)
                        contactRows.append(item)
                    }
                }
                
                if contact.personalPhoneNo.count > 0 {
                    let item = ContactInfor(title: "Personal Phone", value: contact.personalPhoneNo)
                    contactRows.append(item)
                }
                
                if contact.workPhoneNo.count > 0 {
                    let item = ContactInfor(title: "Work Phone", value: contact.workPhoneNo)
                    contactRows.append(item)
                }

                contact.availableServices.forEach {
                    if $0.count > 0 {
                        serviceRows.append($0)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = contact?.person
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        tableViewCellRegister()
    }
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "ContactCell1", bundle: nil), forCellReuseIdentifier: cellIdentifiers.contactCell1.rawValue)
        self.myTableView.register(UINib(nibName: "ContactCell2", bundle: nil), forCellReuseIdentifier: cellIdentifiers.contactCell2.rawValue)
    }
}

extension ContactDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contactRows.count
        } else {
            // service section
            return serviceRows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.contactCell1.rawValue, for: indexPath) as! ContactCell1
            
            let row = contactRows[indexPath.row]
            cell.leftLabel.text = row.title
            cell.rightLabel.text = row.value
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.contactCell2.rawValue, for: indexPath) as! ContactCell2
            
            let service = serviceRows[indexPath.row]
            cell.leftLabel.text = service
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension ContactDetailsViewController: MFMailComposeViewControllerDelegate, OpenEmailComposerDelegate {
    func openMailApp(_ email: String) {
        let recipientEmail = email
        let subject = ""
        let body = ""

        // Show defaul mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)
        } else if let emailUrl = EmailUtilities.createEmailURL(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
