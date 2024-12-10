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
    
    @State private var selectedDate: Date = Date()
    
    var todaySelected: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    // If insights are available for the currently selected date (pre- and post-workout reports filled)
    private var insightsAvailable: Bool {
        guard let user = userDataManager.user else { return false }
        guard let measurements = user.measurements[DateService.compressedDate(from: selectedDate)] else { return false }
        return measurements.keys.contains("predicted") && measurements.keys.contains("actual")
    }
    
    // If the pre-workout report is enabled for today
    private var preUnlocked: Bool {
        guard let user = userDataManager.user else { return false }
        guard let measurements = user.measurements[DateService.compressedDate(from: Date.now)] else { return true }
        return !measurements.keys.contains("predicted") && !measurements.keys.contains("actual")
    }
    
    // If the post-workout report is enabled for today
    private var postUnlocked: Bool {
        guard let user = userDataManager.user else { return false }
        guard let measurements = user.measurements[DateService.compressedDate(from: Date.now)] else { return false }
        return measurements.keys.contains("predicted") && !measurements.keys.contains("actual")
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
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(.indigo)
                    .offset(y: -30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        CalendarView(selectedDate: $selectedDate)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            if todaySelected {
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
                                
                                if !preUnlocked && !postUnlocked {
                                    InsightsView(predicted: getMeasurements(type: .pre, date: selectedDate),
                                                       actual: getMeasurements(type: .post, date: selectedDate))
                                }
                            } else {
                                if insightsAvailable {
                                    InsightsView(predicted: getMeasurements(type: .pre, date: selectedDate),
                                                       actual: getMeasurements(type: .post, date: selectedDate))
                                } else {
                                    Text("No insights available for this date")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
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
    
    private func getMeasurements(type: PromptType, date: Date) -> [Double] {
        guard let user = userDataManager.user else { return [] }
        guard let measurements = user.measurements[DateService.compressedDate(from: date)] else { return [] }
        return measurements[type == .pre ? "predicted" : "actual"] ?? []
    }
}

#Preview {
    HomeView(router: Router(), userDataManager: UserDataManager())
}
