//
//  NewMeetingSecondViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 08/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import CodableFirebase

class NewMeetingSecondViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var meetingNameTextField: UITextField!
    @IBOutlet weak var meetingStreetTextField: UITextField!
    @IBOutlet weak var meetingCityTextField: UITextField!
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    @IBOutlet weak var meetingDatePicker: UIDatePicker!
    @IBOutlet weak var meetingTimeDatePicker: UIDatePicker!
    @IBOutlet weak var meetingBikeTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var meetingDistanceLabel: UILabel!
    @IBOutlet weak var meetingDistanceStepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    let authService = AuthService()
    let firestoreService = FirestoreService<Meeting>()
    
    var meeting: Meeting = Meeting(id: "",
                                   creatorId: "",
                                   name: "",
                                   street: "",
                                   city: "",
                                   timeStamp: 0,
                                   description: "",
                                   bikeType: "",
                                   distance: 0,
                                   latitude: 0,
                                   longitude: 0,
                                   participants:[])
    
    var distance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleActivityIndicator(shown: false)
        
        meetingStreetTextField.text = meeting.street
        meetingCityTextField.text = meeting.city
        meetingDescriptionTextView.text = ""
        meetingDescriptionTextView.layer.borderWidth = 1
        meetingDescriptionTextView.layer.cornerRadius = 5
    }
    
    func setDisplay() {
        
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
    
    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        saveButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    @IBAction func meetingDistanceStepperTapped(_ sender: UIStepper) {
        distance = Int(sender.value)
        meetingDistanceLabel.text = String("\(distance) km")
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        meetingNameTextField.resignFirstResponder()
        meetingStreetTextField.resignFirstResponder()
        meetingCityTextField.resignFirstResponder()
        meetingDescriptionTextView.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        meeting.name = meetingNameTextField.text ?? ""
        meeting.street = meetingStreetTextField.text ?? ""
        meeting.city = meetingCityTextField.text ?? ""
        meeting.description = meetingDescriptionTextView.text ?? ""
        meeting.distance = distance
        
        meeting.timeStamp = meetingDatePicker.date.timeIntervalSince1970
        //meeting.id = "\(meeting.name)\(timeStamp)"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.timeStyle = DateFormatter.Style.short
//        dateFormatter.dateFormat = "dd/MM/yy"
        //meeting.date = dateFormatter.string(from: meetingDatePicker.date)
        
//        let date = meetingTimeDatePicker.date
//        dateFormatter.dateFormat = "HH:mm"
//        meeting.time = dateFormatter.string(from: date)
        
        meeting.bikeType = meetingBikeTypeSegmentedControl.selectedSegmentIndex == 0 ? Constants.Bike.road : Constants.Bike.vtt
        
        if let user = authService.getCurrentUser(),
            let name = user.displayName, let email = user.email {
            meeting.participants = [Participant(name: name, email: email)]
        }
        
        saveMeeting(meeting: meeting)
    }
    
    private func saveMeeting(meeting: Meeting) {
        toggleActivityIndicator(shown: true)
        
        firestoreService.saveData(collection: Constants.Firestore.meetingCollectionName, object: meeting) { [weak self] (error) in
            self?.toggleActivityIndicator(shown: false)
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                print("Meeting sauvegardé")
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
