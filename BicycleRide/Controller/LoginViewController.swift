//
//  LoginViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 01/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func logIn() {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(title: Constants.Alert.Title.incorrect, message: Constants.Alert.enterEmail)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayAlert(title: Constants.Alert.Title.incorrect, message: Constants.Alert.enterPassword)
            return
        }
        
        authService.signIn(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case FirebaseError.unknownEmail:
                    self.displayAlert(title: Constants.Alert.Title.unknownEmail, message: Constants.Alert.checkEmail)
                case FirebaseError.invalidEmail:
                    self.displayAlert(title: Constants.Alert.Title.invalidEmail, message: Constants.Alert.checkEmail)
                case FirebaseError.wrongPassword:
                    self.displayAlert(title: Constants.Alert.Title.wrongPassword, message: Constants.Alert.wrongPassword)
                default:
                    self.displayAlert(title: Constants.Alert.Title.signInFailure, message: "")
                }
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        logIn()
    }
}
