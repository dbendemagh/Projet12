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
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAnnotation(sender:)))
    
    var meeting = Meeting(id: "",
                          creatorId: "",
                          name: "",
                          coordinate: Coordinate(latitude: 0, longitude: 0),
                          date: "",
                          time: "",
                          description: "")
    
    var displayMode = Constants.DisplayMode.Entry
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        //let meeting = Meeting(id: "", creatorId: "", name: "", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), date: "", time: "", description: "")
        
        //let meetingAnnotation = MeetingAnnotation(title: "Ici", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), bikeType: "VTT")
        
        //mapView.addAnnotation(meetingAnnotation)
        
        setupTapGesture()
        setupDisplayMode()
    }
    
    // MARK: - Init Methods
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setupDisplayMode() {
        //if displayMode == .Entry {
        nextButton.isHidden = !(displayMode == .Entry)
        //} else {
        //    nextButton.isHidden = true
        //}
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    private func getCoordinate() {
        for annotation in mapView.annotations {
            if annotation is MeetingAnnotation {
                print("\(annotation.coordinate.latitude) \(annotation.coordinate.longitude)")
                meeting.coordinate.latitude = annotation.coordinate.latitude
                meeting.coordinate.longitude = annotation.coordinate.longitude
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.Annotation.meeting)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.Annotation.meeting)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let meetingAnnotation = view.annotation as? MeetingAnnotation else { return }
        
        displayAlert(title: "Annotation", message: meetingAnnotation.title!)
    }
    
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: Constants.Annotation.regionRadius, longitudinalMeters: Constants.Annotation.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func addAnnotation(sender: UITapGestureRecognizer) {
        print("add annotation")
        removeAnnotations()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MeetingAnnotation(title: "Nouveau", coordinate: touchCoordinate, bikeType: "")
        mapView.addAnnotation(annotation)
        
        let coordinate = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        reverseGeo(location: coordinate)
        
        //let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: Constants.Annotation.regionRadius, longitudinalMeters: Constants.Annotation.regionRadius)
        //mapView.setRegion(coordinateRegion, animated: true)
        
        //doubleTap.isEnabled = false
    }
    
    private func reverseGeo(location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                // Erreur
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            DispatchQueue.main.async {
                self.streetLabel.text = placemark.name
                var meetingCity = ""
                if let postalCode = placemark.postalCode {
                    meetingCity = postalCode
                }
                if let city = placemark.locality {
                    meetingCity += " \(city)"
                }
                self.cityLabel.text = meetingCity
                //self.cityLabel.text = "\(placemark.postalCode) \(placemark.locality)"
            }
            
            print("\(placemark.subThoroughfare) \(placemark.locality) \(placemark.subAdministrativeArea) \(placemark.subLocality) \(placemark.thoroughfare)")
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
        print("setup tapGesture")
        //let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addAnnotation(sender:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
}
