//
//  ChatViewController.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/02/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - Properties
    
    let authService = AuthService()
    let firestoreService = FirestoreService<Message>()
    
    var meetingId: String = ""
    var messages: [AppDocument<Message>] = []
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initListener()
        
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: Constants.Cells.messageCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.messageCell)
        tableView.dataSource = self
    }
    
    private func initListener() {
        firestoreService.addSnapshotListener(collection: Constants.Firestore.messageCollectionName, field: "meetingId", text: meetingId) { (result) in
            switch result {
                case(.failure(let error)):
                    //self.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                    print("Erreur listener : \(error.localizedDescription)")
                case(.success(let messages)):
                    self.messages = messages
                    self.tableView.reloadData()
                    if messages.count > 0 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
            }
        }
    }
    
    // MARK: - Methods
    
    func sendMessage(text: String) {
        if let user = authService.getCurrentUser(), let name = user.displayName, let email = user.email {
            let message = Message(senderName: name, senderEmail: email, meetingId: meetingId, text: text, timeStamp: Date().timeIntervalSince1970)
            firestoreService.saveData(collection: Constants.Firestore.messageCollectionName, object: message) { [weak self] (error) in
                if let error = error {
                    print("Erreur envoi : \(error.localizedDescription)")
                    self?.displayAlert(title: Constants.Alert.alertTitle, message: Constants.Alert.databaseError)
                } else {
                    DispatchQueue.main.async {
                        self?.messageTextField.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if let text = messageTextField.text {
            sendMessage(text: text)
        }
    }
}

// MARK: - TableView Datasource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageDocument = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.messageCell, for: indexPath) as? MessageCell else { return MessageCell() }
        
        let message = messageDocument.data
        cell.senderName.text = messageDocument.data?.senderName
        cell.messageLabel.text = message?.text
        
        cell.leftView.backgroundColor = UIColor.white
        cell.rightView.backgroundColor = UIColor.white
        cell.leftView.alpha = 0
        cell.rightView.alpha = 0
        
        if let user = authService.getCurrentUser() {
            cell.senderName.text = ""
            cell.currentUserName.text = user.displayName
            if messageDocument.data?.senderEmail == user.email {
                // This is a message from the current user
                cell.leftView.isHidden = false
                cell.rightView.isHidden = true
                cell.messageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            } else {
                // This is a message from another user
                cell.senderName.text = messageDocument.data?.senderName
                cell.currentUserName.text = ""
                cell.leftView.isHidden = true
                cell.rightView.isHidden = false
                cell.messageView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
        return cell
    }
}