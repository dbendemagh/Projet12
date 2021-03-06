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
    @IBOutlet weak var meetingDayLabel: UILabel!
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
    
    var meeting: Meeting = Meeting(creatorId: "",
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
        
        initScreen()
    }
    
    private func initScreen() {
        meetingStreetTextField.text = meeting.street
        meetingCityTextField.text = meeting.city
        meetingDescriptionTextView.text = ""
        meetingDescriptionTextView.layer.borderWidth = 1
        meetingDescriptionTextView.layer.cornerRadius = 5
        meetingDayLabel.text = ""
        meetingDatePicker.addTarget(self, action: #selector(meetingDatePickerValueChanged(sender:)), for: .valueChanged)
        meetingDatePickerValueChanged(sender: meetingDatePicker)
    }

    // MARK: - Methods
    
    @objc func meetingDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        meetingDayLabel.text = dateFormatter.string(from: sender.date)
    }
    
    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        saveButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    // MARK: - Action buttons
    
    @IBAction func meetingDistanceStepperTapped(_ sender: UIStepper) {
        distance = Int(sender.value)
        meetingDistanceLabel.text = String("\(distance) km")
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        meeting.name = meetingNameTextField.text ?? ""
        meeting.street = meetingStreetTextField.text ?? ""
        meeting.city = meetingCityTextField.text ?? ""
        meeting.description = meetingDescriptionTextView.text ?? ""
        meeting.distance = distance
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: meetingTimeDatePicker.date)
        let minute = calendar.component(.minute, from: meetingTimeDatePicker.date)
        let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: meetingDatePicker.date)
        if let timeStamp = date?.timeIntervalSince1970 {
            meeting.timeStamp = timeStamp
        }
        
        meeting.bikeType = meetingBikeTypeSegmentedControl.selectedSegmentIndex == 0 ? Constants.Bike.road : Constants.Bike.vtt
        
        if let user = authService.getCurrentUser(),
            let name = user.displayName, let email = user.email {
            meeting.participants = [Participant(name: name, email: email)]
        }
        
        saveMeeting(meeting: meeting)
    }
    
    private func saveMeeting(meeting: Meeting) {
        toggleActivityIndicator(shown: true)
        
        firestoreService.addDocument(collection: Constants.Firestore.meetingsCollection, object: meeting) { [weak self] (error) in
            self?.toggleActivityIndicator(shown: false)
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: Constants.Alert.Title.error, message: Constants.Alert.saveDocumentError)
            } else {
                print("Meeting sauvegardé")
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
