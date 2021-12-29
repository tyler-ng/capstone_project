//
//  SignInViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-01.
//

import UIKit


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var invalidEmailText: UILabel!
    
    @IBOutlet weak var invalidPasswordText: UILabel!
    
    private var error: OpenNewError?
    private var email: String?
    private var password: String?
    private var token: String?
    private var expiration: String?
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invalidEmailText.isHidden = true
        invalidPasswordText.isHidden = true

        emailTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.layer.cornerRadius = 5.0
        
        // add tap guesture action to forgot password label
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordAction(sender:)))
        forgotPasswordLabel.addGestureRecognizer(tapAction)
        forgotPasswordLabel.isUserInteractionEnabled = true
        
        // update data from view model
        viewModel.errorStore.bind { [weak self] error in
            guard let error = error else {
                return
            }
            self?.error = error
            
            // show a sign-in failure alert
            AlertUtilities.showAlert2(self: self!, title: AlertUtilities.signInFailedTitle, message: AlertUtilities.signInFailedMessage, actionTitle: "OK", textColor: UIColor.red)
        }
        
        viewModel.tokenStore.bind { [weak self] tokenInfo in
            guard let tokenInfo = tokenInfo else {
                return
            }
            
            guard let token = tokenInfo["token"] as? String, let expiration = tokenInfo["expiration"] as? String else {
                return
            }
            
            let tokenData = Data(token.utf8)
            let expirationData = Data(expiration.utf8)
            let _ = KeyChain.save(key: "token", data: tokenData)
            let _ = KeyChain.save(key: "expiration", data: expirationData)
            
            self?.forwardToTabBarViewController(self: self)
        }

    }
    
    @objc func forgotPasswordAction(sender: UITapGestureRecognizer) {
        AlertUtilities.showAlert2(self: self, title: AlertUtilities.forgotPasswordTitle, message: AlertUtilities.forgotPasswordMessage, actionTitle: "OK", textColor: UIColor.black)
    }
    
    func forwardToTabBarViewController(self: SignInViewController?) {
        let tabBarViewController = self?.storyboard!.instantiateViewController(identifier: "TabBarVC")
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = tabBarViewController
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if let email = emailTextField.text {
            self.email = email
        }
        
        if let password = passwordTextField.text {
            self.password = password
        }
        
        return true
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        invalidEmailText.isHidden = true
        invalidPasswordText.isHidden = true
        guard let email = email, email.count > 0, let password = password, password.count > 0 else {
            AlertUtilities.showAlert2(
                self: self,
                title: AlertUtilities.signInFieldsEmptyTitle,
                message: AlertUtilities.signInFieldsEmptyMessage,
                actionTitle: "OK",
                textColor: UIColor.red)
            return
        }
        
        if password.count < 6 {
            invalidPasswordText.isHidden = false
        }


        if !email.isEmail {
            invalidEmailText.isHidden = false
        }
        
        if !email.isEmail || password.count < 6 {
            if !email.isEmail {
                return
            }
            
            if password.count < 6 {
                return
            }
        }

        viewModel.userSignInToAPI(email, password)
    }
}
