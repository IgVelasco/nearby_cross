//
//  InterfaceUtils.swift
//  nearby_cross
//
//  Created by Ignacio Velasco on 29/02/2024.
//

import Foundation

class InterfaceUtils {
    static func parseStringAsBoolean(_ strNumber: String) -> Bool? {
        guard let intValue = Int(strNumber) else {
            return nil
        }
        return intValue == 1
    }
}
