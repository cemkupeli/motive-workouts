//
//  User.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

struct User: Identifiable, Codable {
    let id: String
    let measurements: [String: [String: [Float]]] // maps compressed dates to a dictionary corresponding to that day's measurements
}
