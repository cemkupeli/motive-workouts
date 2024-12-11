//
//  HelpView.swift
//  Motive
//
//  Created by Cem Kupeli on 12/11/24.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var userDataManager: UserDataManager
    
    @State private var email: String = ""
    @State private var message: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Need Help?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                Text("If you have questions, feedback, or need assistance, you can submit a help request below. Please provide your email address so we can get back to you, and let us know what's on your mind.")
                    .font(.body)
                
                TextField("Your email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 10)
                
                Text("Your message:")
                    .font(.headline)
                
                TextEditor(text: $message)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
                
                Spacer()
                
                Button("Submit") {
                    Task {
                        do {
                            try await userDataManager.submitSupportRequest(email: email, message: message)
                        } catch {
                            print("Error submitting support request: \(error.localizedDescription)")
                        }
                    }
                    dismiss()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(email.isEmpty || message.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(email.isEmpty || message.isEmpty)
                
                Spacer(minLength: 20)
            }
            .padding()
        }
    }
}

#Preview {
    HelpView(userDataManager: UserDataManager())
}
