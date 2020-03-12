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
    
    // MARK: - Methods
    
    private func createUser() {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayAlert(title: Constants.Alert.Title.incorrect, message: Constants.Alert.enterEmail)
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            displayAlert(title: Constants.Alert.Title.incorrect, message: Constants.Alert.enterName)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayAlert(title: Constants.Alert.Title.incorrect, message: Constants.Alert.enterPassword)
            return
        }
        
        authService.createUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case FirebaseError.emailAlreadyExist:
                    self.displayAlert(title: Constants.Alert.Title.emailAlreadyExist, message: Constants.Alert.enterOtherEmail)
                default:
                    self.displayAlert(title: Constants.Alert.Title.error, message: Constants.Alert.unknownError)
                }
                print(error.localizedDescription)
            case .success(_):
                let userProfile = UserProfile( name: name, email: email, bikeType: "", experience: "")
                
                // Save display name
                self.authService.updateCurrentUser(userProfile: userProfile) { (error) in
                    if error != nil {
                        self.displayAlert(title: Constants.Alert.Title.error, message: Constants.Alert.saveDocumentError)
                    }
                }
                
                self.saveUserProfile(userProfile: userProfile)
                
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func saveUserProfile(userProfile: UserProfile) {
        firestoreService.modifyDocument(id: userProfile.email, collection: Constants.Firestore.userProfilesCollection, object: userProfile) { [weak self] (error) in
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: Constants.Alert.Title.error, message: Constants.Alert.saveDocumentError)
            } else {
                print("Profil sauvegardé")
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        createUser()
    }
}
