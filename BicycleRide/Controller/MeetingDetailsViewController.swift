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
    
    var meetingDocument = Document<Meeting>()
    
    let authService = AuthService()
    let firestoreService = FirestoreService<Meeting>()

    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        initScreen()
    }
    
    private func initScreen() {
        participateButton.isHidden = false
        participateLabel.isHidden = true
        
        if let data = meetingDocument.data {
            meetingNameLabel.text = data.name
            meetingStreetLabel.text = data.street
            meetingCityLabel.text = data.city
            meetingDateTimeLabel.text = "\(data.timeStamp.date()) - \(data.timeStamp.time())"
            meetingDescriptionTextField.text = data.description
            
            meetingDistanceLabel.text = "Distance : \(data.distance) km"
        }
        
        meetingDescriptionTextField.layer.borderWidth = 1
        meetingDescriptionTextField.layer.cornerRadius = 5
        stackViewLabel.isHidden = true
        
        displayParticipants()
        setMeetingPosition()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? ChatViewController {
            chatVC.meetingId = meetingDocument.documentId
        }
    }
    
    
    // MARK: - Methods
    
    private func setMeetingPosition() {
        if let data = meetingDocument.data {
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let annotation = MeetingAnnotation(title: "Point de départ", coordinate: coordinate)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func displayParticipants() {
        let user = authService.getCurrentUser()
        
        if let data = meetingDocument.data {
            for participant in data.participants {
                
                addParticipant(name: participant.name)
                
                if participant.name == user?.displayName {
                    participateButton.isHidden = true
                    participateLabel.isHidden = false
                }
            }
        }
    }
    
    private func addParticipant(name: String) {
        let label = UILabel()
        label.text = name
        meetingParticipantsStackView.addArrangedSubview(label)
    }
    
    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        participateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func participate() {
        if let user = authService.getCurrentUser(),
            let name = user.displayName, let email = user.email,
            var meeting = meetingDocument.data {
                meeting.participants.append(Participant(name: name, email: email))
            
                toggleActivityIndicator(shown: true)
            
            firestoreService.modifyDocument(id: meetingDocument.documentId, collection: Constants.Firestore.meetingsCollection, object: meeting) { (error) in
                    self.toggleActivityIndicator(shown: false)
                    if let _ = error {
                        self.displayAlert(title: Constants.Alert.Title.error, message: Constants.Alert.saveDocumentError)
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
