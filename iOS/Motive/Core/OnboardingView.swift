//
//  OnboardingView.swift
//  Motive
//
//  Created by Cem Kupeli on 12/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var router: Router
    
    private let sampleUserDataManager = UserDataManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(alignment: .center, spacing: 15) {
                    Text("Welcome to Motive!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Motive is a research-based workout tracking application where you can monitor your emotional state across workouts and gain insights that can help you on your fitness journey.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Daily Measurements")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Before you start your workout, you'll complete a pre-workout report.")
                        .font(.body)
                    
                    PromptMeasurementView(type: .pre, unlocked: true)
                        .disabled(true)
                        .opacity(0.7)
                    
                    Text("After your workout, you'll complete a post-workout report.")
                        .font(.body)
                    
                    PromptMeasurementView(type: .post, unlocked: true)
                        .disabled(true)
                        .opacity(0.7)
                    
                    Text("This is how you'll provide your predicted and actual emotional states.")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Insights")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("After completing both your pre- and post-workout reports for the day, you'll gain access to insights showing how your actual post-workout state compared to your predicted state. Here is an example of what these insights might look like:")
                        .font(.body)
                    
                    InsightsView(
                        predicted: [50.0, 40.0, 4.0],
                        actual: [65.0, 28.0, 5.0]
                    )
                    .disabled(true)
                    .opacity(0.7)
                    
                    Text("Valence indicates how pleasant you feel, and arousal indicates how alert you feel.")
                }
                .padding(.horizontal)
                
                Divider()
                
                Button {
                    UserDefaults.standard.hasSeenOnboarding = true
                    router.onboardingSeen = true
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.top, 40)
        }
        .padding(.top)
    }
}

#Preview {
    OnboardingView(router: Router())
}
