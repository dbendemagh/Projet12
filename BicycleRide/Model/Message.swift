//
//  Message.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 02/02/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Message: Codable {
    let senderName: String
    let senderEmail: String
    let meetingId: String
    let text: String
    let timeStamp: Double
}
