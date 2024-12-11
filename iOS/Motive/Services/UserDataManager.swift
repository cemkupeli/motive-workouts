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
    
    func computeAverages() -> (predictedValence: Double?, predictedArousal: Double?, predictedMotivation: Double?,
                               actualValence: Double?, actualArousal: Double?, actualMotivation: Double?, count: Int) {
        guard let user = user else {
            return (nil, nil, nil, nil, nil, nil, 0)
        }
        
        var predictedValenceSum = 0.0
        var predictedArousalSum = 0.0
        var predictedMotivationSum = 0.0
        
        var actualValenceSum = 0.0
        var actualArousalSum = 0.0
        var actualMotivationSum = 0.0
        
        var count = 0
        
        for (_, dayMeasurements) in user.measurements {
            guard let beforeArray = dayMeasurements["predicted"], !beforeArray.isEmpty else { continue }
            guard let afterArray = dayMeasurements["actual"], !afterArray.isEmpty else { continue }
            
            if beforeArray.count == 3 && afterArray.count == 3 {
                predictedValenceSum += beforeArray[0]
                predictedArousalSum += beforeArray[1]
                predictedMotivationSum += beforeArray[2]
                
                actualValenceSum += afterArray[0]
                actualArousalSum += afterArray[1]
                actualMotivationSum += afterArray[2]
                
                count += 1
            }
        }
        
        let predictedValenceAvg = count > 0 ? predictedValenceSum / Double(count) : nil
        let predictedArousalAvg = count > 0 ? predictedArousalSum / Double(count) : nil
        let predictedMotivationAvg = count > 0 ? predictedMotivationSum / Double(count) : nil
        
        let actualValenceAvg = count > 0 ? actualValenceSum / Double(count) : nil
        let actualArousalAvg = count > 0 ? actualArousalSum / Double(count) : nil
        let actualMotivationAvg = count > 0 ? actualMotivationSum / Double(count) : nil
        
        return (predictedValenceAvg, predictedArousalAvg, predictedMotivationAvg,
                actualValenceAvg, actualArousalAvg, actualMotivationAvg, count)
    }
        
    private func syncUserData() throws {
        guard let user else { return }
        let userRef = db.collection("users").document(user.id)
        try userRef.setData(from: user)
    }
}

extension UserDataManager {
    static let testManager = {
        let manager = UserDataManager()
        manager.user = User.testUser
        return manager
    }()
}
