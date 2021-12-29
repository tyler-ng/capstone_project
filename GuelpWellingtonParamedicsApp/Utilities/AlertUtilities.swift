//
//  AlertUtilities.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-25.
//

import UIKit

class AlertUtilities {
    static let title1 = "Patient Id was not provided"
    static let message1 = "Please enter Patient Id and press \"return\" button on the keyboard. Then submit the assessment again."
    static let title2 = "Data was saved"
    static let signInFailedTitle = "Incorrect Email or Password"
    static let signInFailedMessage = "The email or password you entered did not match our records. Please try again."
    static let forgotPasswordTitle = "Forgot Password"
    static let forgotPasswordMessage = "Please contact the application administrator to restore your password."
    static let signInFieldsEmptyTitle = "Cannot Sign In"
    static let signInFieldsEmptyMessage = "Please enter your Email and Password to sign in"
    static let passwordIncorrectTitle = "Password Requirement"
    static let passwordIncorrectMessage = "Password should be minimum 6 characters"
    
    static func showAlert1(self: UIViewController, tableView: UITableView, title: String, message: String, actionTitle: String, action: @escaping () -> Void) {
        tableView.reloadData()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {
            UIAlertAction in
            action()
        })
        self.present(alert, animated: true)
    }
    
    static func showAlert2(self: UIViewController, title: String, message: String, actionTitle: String, textColor: UIColor) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        alert.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor: textColor]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: textColor]), forKey: "attributedMessage")
        
        self.present(alert, animated: true)
    }
}
