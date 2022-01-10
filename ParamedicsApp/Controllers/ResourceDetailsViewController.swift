//
//  ResourceDetailsViewController.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-15.
//

import UIKit
import MessageUI

class ResourceDetailsViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    public var data: Resource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        if let data = data {
            self.title = data.location
        }
        
        tableViewCellRegister()
    }
    
    func tableViewCellRegister() {
        myTableView.register(UINib(nibName: "ContactInforCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.contactInforCell.rawValue)
        myTableView.register(UINib(nibName: "WebsiteURLCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.websiteURLCell.rawValue)
    }

}

extension ResourceDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedCell = tableView.cellForRow(at: indexPath) as? WebsiteURLCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let _ = tappedCell {
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ResourceWebVC") as! ResourceWebViewController
            if let site_url = data?.websiteURL {
                destinationVC.site_url = site_url
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
}

extension ResourceDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let websiteURL = data?.websiteURL, websiteURL.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let webURLString = data?.websiteURL, webURLString.count > 0 { // support to have 2 sections
            if section == 0 {
                return 1
            } else {
                return data?.contacts?.count ?? 0
            }
        } else { // support to have one section
            return data?.contacts?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.websiteURLCell.rawValue, for: indexPath) as! WebsiteURLCell
        // for 2 sections
        if
            let contacts = data?.contacts, contacts.count > 0,
            let webURLString = data?.websiteURL, webURLString.count > 0
        {
            if indexPath.section == 0 {
                
                let canOpenURL = UIApplication.shared.canOpenURL(URL(string: webURLString)!)
                guard canOpenURL == true else { return cell }
                
                cell.websiteLabel.text = webURLString
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.contactInforCell.rawValue, for: indexPath) as! ContactInforCell
                cell.data = contacts[indexPath.row]
                cell.delegate = self
                
                return cell
            }
        } else { // for 1 section that without website URL
            guard let contacts = data?.contacts else { return cell }
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.contactInforCell.rawValue, for: indexPath) as! ContactInforCell
            cell.data = contacts[indexPath.row]
            cell.delegate = self
            
            return cell
        }
    }
}

extension ResourceDetailsViewController: MFMailComposeViewControllerDelegate, OpenEmailComposerDelegate {
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
