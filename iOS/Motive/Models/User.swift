//
//  User.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var measurements: [String: [String: [Double]]] // maps compressed dates to a dictionary corresponding to that day's measurements
}

extension User {
    static let testUser = User(
        id: UUID().uuidString,
        measurements: [
            "01122024": ["predicted": [100, 150, 4], "actual": [125, 130, 6]],
            "02122024": ["predicted": [110, 140, 5], "actual": [128, 129, 7]],
            "03122024": ["predicted": [120, 135, 4], "actual": [123, 133, 6]]
        ]
    )
}
