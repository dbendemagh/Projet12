//
//  MeetingsViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class MeetingsViewController: UIViewController {
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutButtonItemPressed(_ sender: UIBarButtonItem) {
        do {
            try authService.signOut()
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
}
