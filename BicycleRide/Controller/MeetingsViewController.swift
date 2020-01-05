//
//  MeetingsViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class MeetingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let authService = AuthService()
    var meetings: [Meeting] = [Meeting(id: "12", creatorId: "3", name: "Etang de Commelles", date: "10/01/2020", time: "09:00", description: "Balade en forêt")]
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: Constants.Cells.meetingCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.meetingCell)
        tableView.dataSource = self
        
        //tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutButtonItemPressed(_ sender: UIBarButtonItem) {
        do {
            try authService.signOut()
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
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
