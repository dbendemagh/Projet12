//
//  RegisterViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 01/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    let authService = AuthService()
    let firestoreService = FirestoreService<UserProfile>()
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods
    
    private func createUser() {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noEmail)
            return
        }
        
        firestoreService.searchData(collection: Constants.Firestore.userCollectionName, field: "email", text: email) { (result) in
            switch result {
            case .failure(_):
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                return
            case .success(let user):
                if user.count > 0 {
                    self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                    return
                }
            }
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noName)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.noPassword)
            return
        }
        
        authService.createUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(_):
                let userProfile = UserProfile(name: name, email: email, bikeType: "", experience: "")
                self.saveUserProfile(userProfile: userProfile)
                
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func saveUserProfile(userProfile: UserProfile) {
        firestoreService.modifyData(id: userProfile.email, collection: Constants.Firestore.userCollectionName, object: userProfile) { [weak self] (error) in
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                print("Profil sauvegardé")
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        createUser()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
