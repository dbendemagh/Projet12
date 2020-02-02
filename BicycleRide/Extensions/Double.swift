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
        dateFormatter.dateStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "EEEE dd/MM/yy"
        dateFormatter.dateFormat = "E d MMM yyyy HH:mm"
        let test = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        print(test)
        return test
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let test = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        print(test)
        return test
    }
}
