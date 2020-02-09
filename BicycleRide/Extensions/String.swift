//
//  String.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 08/02/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension String {
    func formatedError(path: String, functionName: String) -> String {
        let fileName = URL.init(string: path)?.lastPathComponent ?? ""
        let error = ("*** Error in \(fileName), function \(functionName) : \(self)")
        return error
    }
}
