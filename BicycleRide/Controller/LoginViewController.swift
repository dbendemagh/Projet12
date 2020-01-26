//
//  LoginViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 01/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        logIn()
    }
    
    private func logIn() {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noEmail)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noPassword)
            return
        }
        
        authService.signIn(email: email, password: password) { (result) in
            self.dismiss(animated: true, completion: nil)
            switch result {
            case .failure(_):
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            case .success(_):
                break
            }
        }
    }
}
