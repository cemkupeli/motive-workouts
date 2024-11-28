//
//  HomeView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/16/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var router: Router
    @StateObject var userDataManager: UserDataManager
    
    private var preUnlocked: Bool {
        guard let user = userDataManager.user else { return false }
        guard let measurements = user.measurements[DateService.compressedDate(from: Date.now)] else { return true }
        if measurements.keys.contains("predicted") || measurements.keys.contains("actual") { return false }
        return true
    }
    
    private var postUnlocked: Bool {
        guard let user = userDataManager.user else { return false }
        guard let measurements = user.measurements[DateService.compressedDate(from: Date.now)] else { return false }
        if measurements.keys.contains("predicted") && !measurements.keys.contains("actual") { return true }
        return false
    }
    
    var body: some View {
        Group {
            if userDataManager.user == nil {
                ProgressView("Loading data...")
                    .progressViewStyle(.circular)
            } else {
                Text("Motive")
                    .font(.custom("Kalam-Regular", size: 44).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                    .background(.indigo)
                    .offset(y: -30)
                
                Spacer()
                
                // CalendarView()
                
                Text("UID: \(userDataManager.authUser?.uid ?? "")")
                
                Button {
                    router.currentRoute.append(Route.measurement(type: .pre))
                } label: {
                    PromptMeasurementView(type: .pre, unlocked: preUnlocked)
                }
                .disabled(!preUnlocked)
                
                Button {
                    router.currentRoute.append(Route.measurement(type: .post))
                } label: {
                    PromptMeasurementView(type: .post, unlocked: postUnlocked)
                }
                .disabled(!postUnlocked)
                
                if (!preUnlocked && !postUnlocked) {
                    let predicted = getMeasurements(type: .pre)
                    let actual = getMeasurements(type: .post)
                    Text("Predicted: \(predicted[0]), \(predicted[1]), \(predicted[2])")
                    Text("Actual: \(actual[0]), \(actual[1]), \(actual[2])")
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            Task {
                do {
                    if userDataManager.authUser == nil {
                        try await userDataManager.signIn()
                    }
                    try await userDataManager.fetchUserData()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func getMeasurements(type: PromptType) -> [Double] {
        guard let user = userDataManager.user else { return [] }
        guard let measurements = user.measurements[DateService.compressedDate(from: Date.now)] else { return [] }
        return measurements[type == .pre ? "predicted" : "actual"] ?? []
    }
}

#Preview {
    HomeView(router: Router(), userDataManager: UserDataManager())
}
