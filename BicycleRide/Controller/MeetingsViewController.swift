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
    
    var meetings: [AppDocument<Meeting>] = []
    var selectedRow: Int = 0
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initSnapshotListener()
    }
    
    //override func viewWillAppear(_ animated: Bool) {
    //    super.viewWillAppear(animated)
        
    //}
    
    private func initTableView() {
        tableView.register(UINib(nibName: Constants.Cells.meetingCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.meetingCell)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func initSnapshotListener() {
        firestoreService.addSnapshotListenerForAllDocuments(collection: Constants.Firestore.meetingCollectionName) { (result) in
            switch result {
                case(.failure(let error)):
                    print("Erreur listener : \(error.localizedDescription)")
                case(.success(let meetings)):
                    self.meetings = meetings
                    self.tableView.reloadData()
                    if meetings.count > 0 {
                        let indexPath = IndexPath(row: self.meetings.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
            }
        }
    }
    
    // MARK: - Methods
    
    private func loadMeetings() {
        firestoreService.loadDocuments(collection: Constants.Firestore.meetingCollectionName) { result in
            switch result {
                case(.failure(_)):
                    self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.getDocumentError)
                case(.success(let meetings)):
                    self.meetings = meetings
                    self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let email = authService.getCurrentUser()?.email  else { return }
        
        if let newMeetingVC = segue.destination as? NewMeetingFirstViewController {
            newMeetingVC.meeting = Meeting(creatorId: email, name: "", street: "", city: "", timeStamp: 0, description: "", bikeType: "", distance: 0, latitude: 0, longitude: 0, participants: [])
            newMeetingVC.displayMode = Constants.DisplayMode.Entry
        } else if let meetingDetail = segue.destination as? MeetingDetailsViewController {
            let meeting = meetings[selectedRow]
            meetingDetail.meetingDocument = meeting
        }
    }
    
    // MARK: - Action buttons

    @IBAction func addMeetingButtonItemPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func logOutButtonItemPressed(_ sender: UIBarButtonItem) {
        authService.signOut { (result) in
            switch result {
            case .failure(_):
                self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.logoutError)
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
        if let meeting = meetings[indexPath.row].data {
            cell.configure(meeting: meeting)
        }

        return cell
    }
}

// MARK: - TableView Delegate

extension MeetingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "MeetingDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
