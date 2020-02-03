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
        static let messageCell = "MessageCell"
    }
    
    struct Alert {
        static let alertTitle = "Invalide"
        static let noName = "Entrez votre nom"
        static let noEmail = "Entrez votre adresse mail"
        static let noPassword = "Entrez un mot de passe"
        static let databaseError = "Une erreur est survenue pendant la sauvegarde des données"
        static let loginError = "Login/Mot de passe incorrect"
        static let profileSaved = "Le profil a été sauvegardé."
    }
    
    struct Firestore {
        static let userCollectionName = "user"
        static let meetingCollectionName = "meeting"
        static let messageCollectionName = "message"
    }
    
    struct Annotation {
        static let meetingAnnotation = "MeetingAnnotation"
        static let regionRadius: Double = 4000
    }
    
    struct Bike {
        static let road = "Route"
        static let vtt = "VTT"
    }
    
    enum DisplayMode {
        case Entry
        case View
    }
}

enum FirestoreError : Error {
    case listenerError
    case EmailAlreadyExist
}
