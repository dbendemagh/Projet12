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
        struct Title {
            static let incorrect = "Saisie incorrecte"
            static let invalid = "Invalide"
            static let error = "Erreur"
            static let unknownEmail = "Adresse mail inconnue"
            static let invalidEmail = "Adresse mail invalide"
            static let emailAlreadyExist = "L'adresse mail existe déjà"
            static let wrongPassword = "Mot de passe incorrect"
            static let signInFailure = "Echec de la connexion"
            static let signOutFailure = "Echec de la déconnexion"
        }
        
        static let enterName = "Veuillez entrer votre nom"
        static let enterEmail = "Veuillez entrer votre adresse mail"
        static let checkEmail = "Veuillez vérifier votre adresse mail."
        static let enterOtherEmail = "Veuillez entrer une autre adresse"
        static let enterPassword = "Veuillez entrer votre mot de passe"
        static let wrongPassword = "Veuillez ressaisir votre mot de passe."
        static let profileSaved = "Le profil a été sauvegardé."
        static let getDocumentError = "Une erreur est survenue pendant l'accès aux données."
        static let saveDocumentError = "Une erreur est survenue pendant la sauvegarde des données."
        static let unknownError = "Une erreur inconnue est survenue."
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

enum FirebaseError : Error {
    case listenerError
    case wrongPassword
    case emailAlreadyExist
    case invalidEmail
    case unknownEmail
}
