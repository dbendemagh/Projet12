//
//  TabBarViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthService.addUserConnectionListener { user in
            if user == nil {
                print("Utilisateur déconnecté")
                self.showLogginScreen()
            } else {
                print("Utilisateur connecté")
            }
        }
    }
    
    private func showLogginScreen() {
        DispatchQueue.main.async {
            let loginRegisterSB = UIStoryboard(name: Constants.Storyboard.LoginRegister, bundle: nil)
            let loginVC = loginRegisterSB.instantiateViewController(identifier: Constants.ViewController.Login)
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
