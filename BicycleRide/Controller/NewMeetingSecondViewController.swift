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
                                   distance: 0,
                                   latitude: 0,
                                   longitude: 0,
                                   participants:[])
    
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
        //meeting.participants = ["az@er.com", "bill@yahoo.fr"]
        meeting.participants = [Participant(name: "Bill", email: "bill@free.fr"), Participant(name: "Joe", email: "joe@yahoo.fr")]
        
        //let test = meeting.dictionary
        //print(test)
        //let test = meeting.participants.map($0.dictionary)
        
        //let part: Participant = meeting.participants
        
        //meeting.participants["participants"] = p
        //print(meeting.dictionary)
        saveMeeting(meeting: meeting)
        
    }
    
    private func saveMeeting(meeting: Meeting) { //  meetingData: [String: Any]) {
        print(meeting)
        //print(meeting1.dictionary)
        
//        do {
//            let meetingData: [String: Any] = try FirebaseEncoder().encode(meeting) as! [String : Any]
//            print(meetingData)
//            //saveMeeting(meetingData: meetingData)
//        } catch {
//            print(error)
//        }
        
        firestoreService.addData(collection: Constants.Firestore.meetingCollectionName, object: meeting) { [weak self] (error) in
            if let error = error {
                print("Erreur sauvegarde : \(error.localizedDescription)")
                self?.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            } else {
                print("Meeting sauvegardé")
            }
        }
    }
}
