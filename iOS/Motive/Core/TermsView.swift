//
//  TermsView.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import SwiftUI

extension UserDefaults {
    private enum Keys {
        static let hasAgreedToTerms = "hasAgreedToTerms"
    }

    var hasAgreedToTerms: Bool {
        get { bool(forKey: Keys.hasAgreedToTerms) }
        set { set(newValue, forKey: Keys.hasAgreedToTerms) }
    }
}

struct TermsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var userDataManager = UserDataManager()

    var body: some View {
        VStack {
            ScrollView {
                Text("Terms and conditions")
                    .padding()
            }

            Button {
                agreeToTerms()
            } label: {
                Text("I Agree")
                    .font(.headline)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onReceive(userDataManager.$authUser) { user in
            if user != nil {
                dismiss()
            }
        }
    }

    private func agreeToTerms() {
        UserDefaults.standard.hasAgreedToTerms = true
        userDataManager.signIn()
    }
}

#Preview {
    TermsView()
}
