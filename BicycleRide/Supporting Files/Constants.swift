//
//  Constants.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 18/12/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Constants {
    
    let appName = "🚲 BicycleRide"
    
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
        static let getDocumentError = "Une erreur est survenue pendant l'accès aux données."
        static let saveDocumentError = "Une erreur est survenue pendant la sauvegarde des données"
        static let emailAlreadyExist = "L'adresse mail existe déjà"
        static let loginError = "Login/Mot de passe incorrect"
        static let profileSaved = "Le profil a été sauvegardé."
        static let logoutError = "Une erreur est survenue lors de la déconnexion."
    }
    
    struct Firestore {
        static let userProfilesCollection = "userProfiles"
        static let meetingsCollection = "meetings"
        static let messagesCollection = "messages"
        static let timeStamp = "timeStamp"
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
