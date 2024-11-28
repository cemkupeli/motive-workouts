//
//  User.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

struct User: Identifiable, Codable {
    let id: String
    var measurements: [String: [String: [Double]]] // maps compressed dates to a dictionary corresponding to that day's measurements
}
