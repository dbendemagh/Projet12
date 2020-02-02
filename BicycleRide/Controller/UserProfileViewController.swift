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
    
    let authService = AuthService()
    let firestoreService = FirestoreService<UserProfile>()
    
    var userProfile = AppDocument<UserProfile>() //UserProfile(name: "", email: "", bikeType: "", experience: "")
    var distances:[String] = ["5-10 km", "10-15 km", "15-20 km", "20-25 km", "25-30 km", "30-35 km", "35-40 km", "40-45 km", "45-50 km"]
    var selectedDistance: Int = 0
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleActivityIndicator(shown: false)
        
        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentUser = authService.getCurrentUser(),
            let userProfile = userProfile.data {
            if currentUser.email != userProfile.email {
                initScreen()
            }
        }
        
    }
    
    func initScreen() {
        userNameTextField.text = ""
        userBikeTypeSegmentedControl.selectedSegmentIndex = 0
        userExperiencePickerView.selectRow(0, inComponent: 0, animated: true)
        
        let user = authService.getCurrentUser()
        
        if let name = user?.displayName {
            userNameTextField.text = name
        }
        
        if let email = user?.email {
            loadUserProfile(email: email)
        }
    }
    
    
    // MARK: - Methods
    
    func loadUserProfile(email: String) {
        toggleActivityIndicator(shown: true)
        
        firestoreService.searchData(collection: Constants.Firestore.userCollectionName, field: "email", text: email) { (result) in
            self.toggleActivityIndicator(shown: false)
            switch result {
            case .failure(_):
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            case .success(let userProfiles):
                if let userProfile = userProfiles.first {
                    self.userProfile = userProfile
                    self.displayUserProfile()
                }
            }
        }
    }
    
    func saveUserProfile() {
        guard let name = userNameTextField.text else {
            displayAlert(title: "", message: Constants.Alert.noName)
            return
        }
        
        guard var userProfileData = userProfile.data else {
            return
        }
        
        userProfileData.name = name
        userProfileData.bikeType = userBikeTypeSegmentedControl.selectedSegmentIndex == 0 ? Constants.Bike.road : Constants.Bike.vtt
        userProfileData.experience = distances[selectedDistance]
            
        toggleActivityIndicator(shown: true)
        
        firestoreService.modifyData(id: userProfile.documentId, collection: Constants.Firestore.userCollectionName, object: userProfileData) { (error) in
            if let _ = error {
                self.toggleActivityIndicator(shown: false)
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                self.authService.updateCurrentUser(userProfile: userProfileData) { (error) in
                    self.toggleActivityIndicator(shown: false)
                    if error != nil {
                        self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                    } else {
                        self.displayAlert(title: "", message: Constants.Alert.profileSaved)
                    }
                }
            }
        }
    }
    
    func displayUserProfile() {
        guard let userProfile = userProfile.data else {
            return
        }
        
        userNameTextField.text = userProfile.name ?? ""
        
        if let experience = userProfile.experience,
            let index = distances.firstIndex(of: experience) {
            selectedDistance = index
            userExperiencePickerView.selectRow(selectedDistance, inComponent: 0, animated: true)
        }
        
        userBikeTypeSegmentedControl.selectedSegmentIndex = userProfile.bikeType == Constants.Bike.road ? 0 : 1
    }

    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        saveButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveUserProfile()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        userNameTextField.resignFirstResponder()
    }
}

extension UserProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distances.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distances[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDistance = pickerView.selectedRow(inComponent: 0)
    }
}
