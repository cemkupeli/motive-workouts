//
//  UserDataManager.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserDataManager: ObservableObject {
    @Published var authUser: FirebaseAuth.User?
    @Published var user: User?
    
    private var db = Firestore.firestore()

    func signIn() async throws {
        if Auth.auth().currentUser == nil {
            let authResult = try await Auth.auth().signInAnonymously()
            
            self.authUser = authResult.user
            
            try self.initializeUserData(for: authResult.user.uid)
            print("Initialized user data")
        } else {
            self.authUser = Auth.auth().currentUser
        }
    }
    
    func initializeUserData(for id: String) throws {
        let newUser = User(id: id, measurements: [:])
        let userRef = db.collection("users").document(id)
        try userRef.setData(from: newUser)
    }
    
    func fetchUserData() async throws {
        guard let id = authUser?.uid else { return }
        let userRef = db.collection("users").document(id)
        let document = try await userRef.getDocument()
        user = try document.data(as: User.self)
    }
    
    func setMeasurements(type: PromptType, measurements: [Double]) {
        guard var user else { return }
        
        let date = DateService.compressedDate(from: Date.now)
        let key = type == .pre ? "predicted" : "actual"
        
        if user.measurements[date] == nil { user.measurements[date] = [:] }
        user.measurements[date]?[key] = measurements
        
        self.user = user
        
        Task {
            do {
                try syncUserData()
            } catch {
                print("Error saving user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func syncUserData() throws {
        guard let user else { return }
        let userRef = db.collection("users").document(user.id)
        try userRef.setData(from: user)
    }
}
