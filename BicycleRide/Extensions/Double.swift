//
//  Double.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/02/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Double {
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        let dateTime = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        return dateTime
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        return time
    }
}
