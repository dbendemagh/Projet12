//
//  NewMeetingSecondViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 08/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class NewMeetingSecondViewController: UIViewController {

    @IBOutlet weak var meetingNameTextField: UITextField!
    @IBOutlet weak var meetingStreetTextField: UITextField!
    @IBOutlet weak var meetingCityTextField: UITextField!
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    @IBOutlet weak var meetingDatePicker: UIDatePicker!
    @IBOutlet weak var meetingTimeDatePicker: UIDatePicker!
    @IBOutlet weak var meetingBikeTypeSegmentedControl: UISegmentedControl!
    
    let firestoreService = FirestoreService<Meeting>()
    
    // coordinate: Coordinate(latitude: "", longitude: ""),
    var meeting: Meeting = Meeting(creatorId: "",
                                   name: "",
                                   street: "",
                                   city: "",
                                   date: "",
                                   time: "",
                                   description: "",
                                   bikeType: "",
                                   latitude: "",
                                   longitude: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meetingStreetTextField.text = meeting.street
        meetingCityTextField.text = meeting.city
        meetingDescriptionTextView.text = ""
        meetingDescriptionTextView.layer.borderWidth = 1
        meetingDescriptionTextView.layer.cornerRadius = 5
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.timeStyle = DateFormatter.Style.short
//        if let testDate = dateFormatter.date(from: "10/05/20, 7:15 PM") {
//            meetingDatePicker.date = testDate
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveButtonTapped(_ sender: Any) {
        meeting.name = meetingNameTextField.text ?? ""
        meeting.street = meetingStreetTextField.text ?? ""
        meeting.city = meetingCityTextField.text ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yy"
        meeting.date = dateFormatter.string(from: meetingDatePicker.date)
        
        print(meeting.date)
        
        let date = meetingTimeDatePicker.date
        dateFormatter.dateFormat = "HH:mm"
        meeting.time = dateFormatter.string(from: date)
        print(meeting.time)
        
        meeting.bikeType = meetingBikeTypeSegmentedControl.selectedSegmentIndex == 0 ? Constants.Bike.road : Constants.Bike.vtt
        
        saveMeeting(meeting1: meeting)
    }
    
    private func saveMeeting(meeting1: Meeting) {
        print(meeting1)
        print(meeting1.dictionary)
        firestoreService.addData(collection: Constants.Firestore.meetingCollectionName, data: meeting.dictionary) { [weak self] (error) in
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: "Aïe", message: Constants.Alert.databaseError)
            } else {
                print("Meeting sauvegardé")
            }
        }
    }
}
