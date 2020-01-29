//
//  MeetingDetailsViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 27/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import MapKit

class MeetingDetailsViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var meetingNameLabel: UILabel!
    @IBOutlet weak var meetingDateTimeLabel: UILabel!
    @IBOutlet weak var meetingStreetLabel: UILabel!
    @IBOutlet weak var meetingCityLabel: UILabel!
    @IBOutlet weak var meetingDescriptionLabel: UILabel!
    @IBOutlet weak var meetingDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var meeting = Meeting(creatorId: "", name: "", street: "", city: "", date: "", time: "", description: "", bikeType: "", distance: 0, latitude: 0, longitude: 0, participants: [])
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initScreen()
    }
    
    func initScreen() {
        meetingNameLabel.text = meeting.name
        meetingStreetLabel.text = meeting.street
        meetingCityLabel.text = meeting.city
        meetingDateTimeLabel.text = ("\(meeting.date) \(meeting.time)")
        meetingDescriptionLabel.text = meeting.description
        meetingDistanceLabel.text = String(meeting.distance)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func participateButtonTapped(_ sender: UIButton) {
    }
}
