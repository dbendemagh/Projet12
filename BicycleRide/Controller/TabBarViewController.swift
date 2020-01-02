//
//  TabBarViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let authService = AuthService()
        try! authService.signOut()
        
        checkIfUserLoggedIn()
    }
    
    private func checkIfUserLoggedIn() {
        DispatchQueue.main.async {
            if AuthService.getCurrentUser() == nil {
                //self.performSegue(withIdentifier: "LoginRegister", sender: self)
                let loginRegisterSB = UIStoryboard(name: Constants.Storyboard.LoginRegister, bundle: nil)
                let loginVC = loginRegisterSB.instantiateViewController(identifier: Constants.ViewController.Login)
                self.present(loginVC, animated: true, completion: nil)
            } else {
                print("Déjà connecté")
            }
        }
    }
}
