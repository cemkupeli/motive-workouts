//
//  SummaryView.swift
//  Motive
//
//  Created by Cem Kupeli on 12/11/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var userDataManager: UserDataManager
    
    var body: some View {
        let averages = userDataManager.computeAverages()
        
        VStack(spacing: 20) {
            if averages.count == 0 {
                Text("No data available.")
                    .font(.headline)
                    .padding()
            } else {
                Text("You have logged measurements for \(averages.count) day\(averages.count > 1 ? "s" : "").")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 15) {
                        Text("Average Valence and Arousal")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("")
                                    .frame(width: 80, alignment: .leading)
                                Spacer()
                                Text("Predicted")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 80, alignment: .center)
                                Spacer()
                                Text("Actual")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 80, alignment: .center)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Valence:")
                                    .fontWeight(.semibold)
                                    .frame(width: 80, alignment: .leading)
                                Spacer()
                                Text(averages.predictedValence != nil ? "\(Int(averages.predictedValence!))" : "N/A")
                                    .frame(width: 80, alignment: .center)
                                Spacer()
                                Text(averages.actualValence != nil ? "\(Int(averages.actualValence!))" : "N/A")
                                    .frame(width: 80, alignment: .center)
                            }
                            
                            HStack {
                                Text("Arousal:")
                                    .fontWeight(.semibold)
                                    .frame(width: 80, alignment: .leading)
                                Spacer()
                                Text(averages.predictedArousal != nil ? "\(Int(averages.predictedArousal!))" : "N/A")
                                    .frame(width: 80, alignment: .center)
                                Spacer()
                                Text(averages.actualArousal != nil ? "\(Int(averages.actualArousal!))" : "N/A")
                                    .frame(width: 80, alignment: .center)
                            }
                        }
                    }
                    
                    let motivationAvg = computeMotivationAverage(
                        predicted: averages.predictedMotivation,
                        actual: averages.actualMotivation
                    )
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Average Motivation")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(motivationAvg != nil ? String(format: "%.2f", motivationAvg!) : "N/A")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.top, 5)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func computeMotivationAverage(predicted: Double?, actual: Double?) -> Double? {
        let bothAvailable = (predicted != nil && actual != nil)
        let oneAvailable = (predicted != nil || actual != nil)
        
        if bothAvailable {
            return (predicted! + actual!) / 2.0
        } else if oneAvailable {
            return predicted ?? actual
        } else {
            return nil
        }
    }
}

#Preview {
    SummaryView(userDataManager: UserDataManager.testManager)
}
