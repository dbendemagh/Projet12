//
//  RoundButton.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 30/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 5
    }
}

