//
//  UIStackView.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 30/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

extension UIStackView {
    func setBackground() {
        if self.subviews.count == 2 {
            let backgroundView = UIView(frame: frame)
            backgroundView.backgroundColor = UIColor.darkGray
            backgroundView.alpha = 0.4
            backgroundView.layer.cornerRadius = 5.0
            backgroundView.layer.borderColor = UIColor.white.cgColor
            backgroundView.layer.borderWidth = 3
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.insertSubview(backgroundView, at: 0)
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
        }
    }
}
