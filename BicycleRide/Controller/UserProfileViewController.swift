//
//  UserProfileViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 29/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userBikeTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userExperiencePickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var currentUserProfile = UserProfile(name: "", email: "", bikeType: "", experience: "")
    
    let authService = AuthService()
    let firestoreService = FirestoreService<UserProfile>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleActivityIndicator(shown: false)
        
        initUserProfile()
    }
    
    func initUserProfile() {
        let user = authService.getCurrentUser()
        
        if let name = user?.displayName {
            currentUserProfile.name = name
            displayUserProfile()
        }
        
        if let email = user?.email {
            currentUserProfile.email = email
            
            firestoreService.searchData(collection: Constants.Firestore.userCollectionName, field: "email", text: email) { (result) in
                switch result {
                case .failure(_):
                    self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                case .success(let userProfiles):
                    if let userProfile = userProfiles.first {
                        self.currentUserProfile = userProfile
                        self.displayUserProfile()
                    }
                }
            }
        }
    }

    func displayUserProfile() {
        userNameTextField.text = currentUserProfile.name ?? ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        saveButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = userNameTextField.text else {
            displayAlert(title: "", message: Constants.Alert.noName)
            return
        }
        
        currentUserProfile.name = name
        
        toggleActivityIndicator(shown: true)
        
        firestoreService.saveData(collection: Constants.Firestore.userCollectionName, object: currentUserProfile) { (error) in
            if let _ = error {
                self.toggleActivityIndicator(shown: false)
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                self.authService.updateCurrentUser(userProfile: self.currentUserProfile) { (error) in
                    self.toggleActivityIndicator(shown: false)
                    if error != nil {
                        self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                    }
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        userNameTextField.resignFirstResponder()
    }
}
