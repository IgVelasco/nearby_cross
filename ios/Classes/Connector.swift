//
//  NCAdvertiser.swift
//  nearby_cross
//
//  Created by Ignacio Velasco on 29/02/2024.
//

import Foundation


import Foundation

class Connector {
    let serviceId: String
    let context: UIApplication
    let callbacks: ConnectionCallbacks
    let userName: Data
    let strategy: Strategy
    var manualAcceptConnections: Bool

    init(serviceId: String,
         strategy: String,
         context: UIApplication,
         callbacks: ConnectionCallbacks,
         userName: String = GeneralConstants.DEFAULT_USERNAME,
         manualAcceptConnections: Bool = false) {
        self.serviceId = serviceId
        self.context = context
        self.callbacks = callbacks
        self.userName = userName.data(using: .utf8)!
        self.strategy = getStrategy(strategy)
        self.manualAcceptConnections = manualAcceptConnections
    }
}
