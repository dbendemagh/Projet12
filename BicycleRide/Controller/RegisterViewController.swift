//
//  RegisterViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 01/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authService = AuthService()
    let firestoreService = FirestoreService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(AuthService.getCurrentUser() ?? "pas de user")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signUpButtonPressed(_ sender: Any) {
        createUser()
    }
    
    private func createUser() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noName)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noEmail)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noPassword)
            return
        }
        
        authService.createUSer(email: email, password: password) { (authDataResult, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let authDataResult = authDataResult {
                    //print(AuthService.getCurrentUser() ?? "")
                    
                    let user = UserProfile(id: authDataResult.user.uid, email: email, name: name)
                    self.saveUserProfile(userProfile: user)
                    
                    self.dismiss(animated: true, completion: nil)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func saveUserProfile(userProfile: UserProfile) {
        //let user = UserProfile(id: userProfile.id, email: userProfile.email, name: userProfile.name)
        firestoreService.saveData(collection: Constants.Firestore.userCollectionName, data: userProfile.dictionary) { [weak self] (error) in
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: "Aïe", message: Constants.Alert.databaseError)
            } else {
                print("Profil sauvegardé")
            }
        }
    }
}
