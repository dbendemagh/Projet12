//
//  TabBarViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserConnectionListener()
    }
    
    private func setupUserConnectionListener() {
        authService.addUserConnectionListener { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                break
            }
        }
        
        authService.addUserConnectionListener { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let connected):
                if connected {
                    print("Utilisateur connecté")
                } else {
                    print("Utilisateur déconnecté")
                }
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
