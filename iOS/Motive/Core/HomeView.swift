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
                
                Text(DateService.fullDate(from: Date.now))
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                // CalendarView()
                
                // Text("UID: \(userDataManager.authUser?.uid ?? "")")
                
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
                    let measurementTitles = ["Valence", "Arousal", "Motivation"]
                    let predicted = getMeasurements(type: .pre)
                    let actual = getMeasurements(type: .post)
                    
                    Text("You've completed your workout for today!")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 10)
                    
                    Grid(alignment: .center) {
                        GridRow {
                            Text("")
                                .fontWeight(.bold)
                            ForEach(0..<3, id: \.self) { index in
                                Text(measurementTitles[index])
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Predicted:")
                                .fontWeight(.bold)
                            ForEach(0..<3, id: \.self) { index in
                                Text("\(Int(round(predicted[index])))")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Actual:")
                                .fontWeight(.bold)
                            ForEach(0..<3, id: \.self) { index in
                                HStack(spacing: 4) {
                                    IndicatorView(difference: actual[index] - predicted[index])
                                        .frame(width: 10, height: 10)
                                    Text("\(Int(round(actual[index])))")
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
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
