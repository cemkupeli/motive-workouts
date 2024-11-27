//
//  UserDataManager.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import Foundation
import FirebaseAuth

class UserDataManager: ObservableObject {
    @Published var authUser: FirebaseAuth.User?
    @Published var user: User?

    init() {
        listenToAuthState()
    }

    private func listenToAuthState() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.authUser = user
        }
    }

    func signIn() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { [weak self] authResult, error in
                if let error = error {
                    print("Anonymous sign-in failed: \(error.localizedDescription)")
                    return
                }
                self?.authUser = authResult?.user
            }
        } else {
            self.authUser = Auth.auth().currentUser
        }
    }
}
