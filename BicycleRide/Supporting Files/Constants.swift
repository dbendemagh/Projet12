//
//  Constants.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 18/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        static let LoginRegister = "LoginRegister"
    }
    
    struct ViewController {
        static let Login = "Login"
    }
    
    struct Cells {
        static let meetingCell = "MeetingCell"
        static let chatCell = "ChatCell"
    }
    
    struct Alert {
        static let alertTitle = "Invalide"
        static let noName = "Entrez votre nom"
        static let noEmail = "Entrez votre adresse mail"
        static let noPassword = "Entrez un mot de passe"
        static let databaseError = "Une erreur est survenue pendant la sauvegarde des données"
    }
    
    struct Firestore {
        static let userCollectionName = "user"
        static let meetingCollectionName = "meeting"
    }
    
    struct Annotation {
        static let meeting = "MeetingAnnotation"
        static let regionRadius: Double = 4000
    }
    
    enum DisplayMode {
        case Entry
        case View
    }
}
