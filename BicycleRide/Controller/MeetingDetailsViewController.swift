//
//  MeetingDetailsViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MeetingDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var meetingNameLabel: UILabel!
    @IBOutlet weak var meetingDateTimeLabel: UILabel!
    @IBOutlet weak var meetingStreetLabel: UILabel!
    @IBOutlet weak var meetingCityLabel: UILabel!
    @IBOutlet weak var meetingDescriptionTextField: UITextView!
    @IBOutlet weak var meetingDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var meetingParticipantsStackView: UIStackView!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var participateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewLabel: UILabel!
    
    // MARK: - Properties
    
    var meeting = Meeting(id: "", creatorId: "", name: "", street: "", city: "", timeStamp: 0, description: "", bikeType: "", distance: 0, latitude: 0, longitude: 0, participants: [])
    
    let authService = AuthService()
    let firestoreService = FirestoreService<Meeting>()

    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        initScreen()
    }
    
    func initScreen() {
        
        participateButton.isHidden = false
        participateLabel.isHidden = true
        meetingNameLabel.text = meeting.name
        meetingStreetLabel.text = meeting.street
        meetingCityLabel.text = meeting.city
        meetingDateTimeLabel.text =  meeting.timeStamp.date()  //("\(meeting.date) \(meeting.time)")
        meetingDescriptionTextField.text = meeting.description
        meetingDescriptionTextField.layer.borderWidth = 1
        meetingDescriptionTextField.layer.cornerRadius = 5
        meetingDistanceLabel.text = "Distance : \(meeting.distance) km"
        stackViewLabel.isHidden = true
        
        displayParticipants()
        setMeetingPosition()
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
    
    func setMeetingPosition() {
        let coordinate = CLLocationCoordinate2D(latitude: meeting.latitude, longitude: meeting.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MeetingAnnotation(title: "Point de départ", coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }
    
    func displayParticipants() {
        let user = authService.getCurrentUser()
        
        for participant in meeting.participants {
            
            addParticipant(name: participant.name)
            
            if participant.name == user?.displayName {
                participateButton.isHidden = true
                participateLabel.isHidden = false
            }
        }
    }
    
    func addParticipant(name: String) {
        let label = UILabel()
        label.text = name
        meetingParticipantsStackView.addArrangedSubview(label)
    }
    
    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        participateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    func participate() {
        if let user = authService.getCurrentUser(),
            let name = user.displayName, let email = user.email {
            meeting.participants.append(Participant(name: name, email: email))
            
            toggleActivityIndicator(shown: true)
            
            firestoreService.modifyData(id: meeting.id, collection: Constants.Firestore.meetingCollectionName, object: meeting) { (error) in
                self.toggleActivityIndicator(shown: false)
                if let _ = error {
                    self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                } else {
                    self.addParticipant(name: name)
                    self.participateButton.isHidden = true
                    self.participateLabel.isHidden = false
                }
            }
        }
    }
    
    @IBAction func participateButtonTapped(_ sender: UIButton) {
        participate()
    }
}
