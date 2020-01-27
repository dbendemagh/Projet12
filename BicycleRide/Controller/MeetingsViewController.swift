//
//  MeetingsViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import MapKit

class MeetingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let authService = AuthService()
    let firestoreService = FirestoreService<Meeting>()
    
    var meetings: [Meeting] = []
        //[Meeting(id: "12", creatorId: "3", name: "Etang de Commelles", coordinate: Coordinate(latitude: 48.8567, longitude: 2.3508), date: "10/01/2020", time: "09:00", description: "Balade en forêt")]
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
        firestoreService.loadData(collection: Constants.Firestore.meetingCollectionName) { result in
            switch result {
                case(.failure(_)):
                    self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                case(.success(let meetings)):
                    self.meetings = meetings
                    self.tableView.reloadData()
            }
        }
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: Constants.Cells.meetingCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.meetingCell)
        tableView.dataSource = self
        
        //tableView.reloadData()
    }

    private func loadMeetings() {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let email = authService.getCurrentUser()?.email  else { return }
        
        if let newMeetingVC = segue.destination as? NewMeetingFirstViewController {
            newMeetingVC.meeting = Meeting(creatorId: email, name: "", street: "", city: "", date: "", time: "", description: "", bikeType: "", latitude: 0, longitude: 0)
            newMeetingVC.displayMode = Constants.DisplayMode.Entry
        }
    }
    
    // MARK: - Action buttons

    @IBAction func addMeetingButtonItemPressed(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func logOutButtonItemPressed(_ sender: UIBarButtonItem) {
        authService.signOut { (result) in
            switch result {
            case .failure(_):
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
            case .success(_):
                break
            }
        }
    }
}

// MARK: - TableView DataSource

extension MeetingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.meetingCell, for: indexPath) as? MeetingCell else {
            return UITableViewCell()
        }
        
        cell.configure(meeting: meetings[indexPath.row])

        return cell
    }
}

//extension MeetingsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}
