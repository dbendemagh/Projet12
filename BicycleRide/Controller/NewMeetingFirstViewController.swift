//
//  MeetingViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 07/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewMeetingFirstViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressStackView: UIStackView!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAnnotation(sender:)))
    
    var meeting: Meeting = Meeting(id: "",
                                   creatorId: "",
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
                                   participants: [])
    
    var displayMode = Constants.DisplayMode.Entry
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDisplay()
        
        setupLocationManager()
        
        setupTapGesture()
        setupDisplayMode()
    }
    
    func initDisplay() {
        addressStackView.setBackground()
        streetLabel.text = " Indiquez le point de départ"
        cityLabel.text = " "
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setupDisplayMode() {
        nextButton.isHidden = !(displayMode == .Entry)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newMeetingVC = segue.destination as? NewMeetingSecondViewController {
            newMeetingVC.meeting = Meeting(id: "",
                                           creatorId: meeting.creatorId,
                                           name: meeting.name,
                                           street: meeting.street,
                                           city: meeting.city,
                                           date: meeting.date,
                                           time: meeting.time,
                                           description: meeting.description,
                                           bikeType: meeting.bikeType,
                                           distance: meeting.distance,
                                           latitude: meeting.latitude,
                                           longitude: meeting.longitude,
                                           participants: meeting.participants)
        }
    }
    
    // MARK: - Methods
    
    private func getCoordinate() {
        for annotation in mapView.annotations {
            if annotation is MeetingAnnotation {
                print("\(annotation.coordinate.latitude) \(annotation.coordinate.longitude)")
                meeting.latitude = annotation.coordinate.latitude
                meeting.longitude = annotation.coordinate.longitude
            }
        }
    }
    
    // MARK: - Action buttons
    
    @IBAction func centerMapButtonPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
}

// MARK: - Location Manager Delegate

extension NewMeetingFirstViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - MapView Delegate

extension NewMeetingFirstViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MeetingAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.Annotation.meetingAnnotation)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.Annotation.meetingAnnotation)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: Constants.Annotation.regionRadius, longitudinalMeters: Constants.Annotation.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func addAnnotation(sender: UITapGestureRecognizer) {
        removeAnnotations()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        meeting.longitude = Double(touchCoordinate.longitude)
        meeting.latitude = Double(touchCoordinate.latitude)
        let annotation = MeetingAnnotation(title: "Point de départ", coordinate: touchCoordinate)
        mapView.addAnnotation(annotation)
        
        let coordinate = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        reverseGeo(location: coordinate)
    }
    
    // Find Address from Geo location
    private func reverseGeo(location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            DispatchQueue.main.async {
                self.meeting.street = placemark.name!
                self.meeting.city = ""
                if let postalCode = placemark.postalCode {
                    self.meeting.city = postalCode
                }
                if let city = placemark.locality {
                    self.meeting.city += " \(city)"
                }
                self.streetLabel.text = " \(self.meeting.street)"
                self.cityLabel.text = " \(self.meeting.city)"
            }
        }
    }
    
    private func removeAnnotations() {
        for annotation in mapView.annotations {
            if annotation is MeetingAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
}

// MARK: - Gesture Recognizer Delegate

extension NewMeetingFirstViewController: UIGestureRecognizerDelegate {
    func setupTapGesture() {
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
}
