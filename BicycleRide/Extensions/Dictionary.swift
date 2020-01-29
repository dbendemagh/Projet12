//
//  Dictionary.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 20/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Dictionary {
    func decoded<T: Decodable>() -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let object = try JSONDecoder().decode(T.self, from: jsonData)
            print(object)
            return object
        } catch {
            print("Erreur Dictionary.decoded : \(error)")
            return nil
        }
    }
}
