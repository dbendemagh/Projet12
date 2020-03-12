//
//  TabBarViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 31/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Properties
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserConnectionListener()
    }
    
    // MARK: - Methods
    
    // User connection status
    private func setupUserConnectionListener() {
        authService.addUserConnectionListener { (connected) in
            if !connected {
                self.showLogginScreen()
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
