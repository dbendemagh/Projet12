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
    
    var pickerDistances:[String] = ["5-10 km", "10-15 km ", "15-20 km", "20-25 km", "25-30 km", "30-35 km", "35-40 km", "40-45 km", "45-50 km"]
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleActivityIndicator(shown: false)
        
        initUserProfile()
        //initScreen()
    }
    
//    func initScreen() {
//        if let experience = currentUserProfile.experience,
//            let row = pickerDistances.firstIndex(of: experience) {
//            userExperiencePickerView.selectRow(row, inComponent: 0, animated: true)
//        }
//    }
    
    func initUserProfile() {
        let user = authService.getCurrentUser()
        
        if let name = user?.displayName {
            currentUserProfile.name = name
            displayUserProfile()
        }
        
        if let email = user?.email {
            currentUserProfile.email = email
            
            toggleActivityIndicator(shown: true)
            
            firestoreService.searchData(collection: Constants.Firestore.userCollectionName, field: "email", text: email) { (result) in
                self.toggleActivityIndicator(shown: false)
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
        
        if let experience = currentUserProfile.experience,
            let row = pickerDistances.firstIndex(of: experience) {
            userExperiencePickerView.selectRow(row, inComponent: 0, animated: true)
        }
        
        if currentUserProfile.bikeType == "Route" {
            userBikeTypeSegmentedControl.selectedSegmentIndex = 0
        } else {
            userBikeTypeSegmentedControl.selectedSegmentIndex = 1
        }
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
        
        if userBikeTypeSegmentedControl.selectedSegmentIndex == 0 {
            currentUserProfile.bikeType = Constants.Bike.road
        } else {
            currentUserProfile.bikeType = Constants.Bike.vtt
        }
        
        toggleActivityIndicator(shown: true)
        
        firestoreService.modifyData(id: currentUserProfile.email, collection: Constants.Firestore.userCollectionName, object: currentUserProfile) { (error) in
            if let _ = error {
                self.toggleActivityIndicator(shown: false)
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                self.authService.updateCurrentUser(userProfile: self.currentUserProfile) { (error) in
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
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        userNameTextField.resignFirstResponder()
    }
}

extension UserProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDistances.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDistances[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentUserProfile.experience = pickerDistances[pickerView.selectedRow(inComponent: 0)]
    }
}
