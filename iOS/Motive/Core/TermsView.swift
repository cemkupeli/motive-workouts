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
    @StateObject var router: Router

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
    }

    private func agreeToTerms() {
        UserDefaults.standard.hasAgreedToTerms = true
        router.agreedToTerms = true
    }
}

#Preview {
    TermsView(router: Router())
}
