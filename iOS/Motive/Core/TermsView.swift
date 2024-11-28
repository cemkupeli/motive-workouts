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
                VStack(alignment: .leading, spacing: 15) {
                    Text("Terms and Conditions")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("**1. Acceptance of Terms**")
                    Text("By using this app, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.")
                    
                    Text("**2. Data Collection and Use**")
                    Text("You acknowledge and agree that the app will collect data regarding your measurements. This data may include, but is not limited to, emotional states, motivation levels, and other related metrics. The collected data will be used for research purposes to improve the app and contribute to scientific understanding.")
                    
                    Text("**3. Privacy**")
                    Text("We are committed to protecting your privacy. Your data will be anonymized and stored securely. We will not share your personal information with third parties without your consent, except as required by law.")
                    
                    Text("**4. No Liability**")
                    Text("The app owner is not liable for any outcomes associated with the use of this app. This includes, but is not limited to, any direct, indirect, incidental, or consequential damages arising out of your use or inability to use the app.")
                    
                    Text("**5. No Medical Advice**")
                    Text("The app is not intended to provide medical advice or diagnoses. Always seek the advice of a qualified health provider with any questions you may have regarding a medical condition.")
                    
                    Text("**6. Changes to Terms**")
                    Text("We reserve the right to modify these Terms and Conditions at any time. Any changes will be effective immediately upon posting within the app. Your continued use of the app constitutes your acceptance of the revised terms.")
                    
                    Text("**7. Governing Law**")
                    Text("These terms shall be governed and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.")
                    
                    Text("**8. Contact Us**")
                    Text("If you have any questions about these Terms and Conditions, please contact us at cemkupeli.dev@gmail.com")
                }
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
