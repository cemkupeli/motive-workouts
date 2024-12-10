//
//  InsightsView.swift
//  Motive
//
//  Created by Cem Kupeli on 12/10/24.
//

import SwiftUI

struct InsightsView: View {
    let predicted: [Double]
    let actual: [Double]
    
    var body: some View {
        let measurementTitles = ["Valence", "Arousal",  "Motivation"]
        
        Text("Workout Summary")
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, 20)
            .multilineTextAlignment(.center)
        
        // Valence and arousal insights
        Grid(alignment: .center) {
            GridRow {
                Text("")
                    .fontWeight(.bold)
                ForEach(0..<2, id: \.self) { index in
                    Text(measurementTitles[index])
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            Divider()
            GridRow {
                Text("Predicted:")
                    .fontWeight(.bold)
                ForEach(0..<2, id: \.self) { index in
                    Text("\(Int(round(predicted[index])))")
                        .frame(maxWidth: .infinity)
                }
            }
            Divider()
            GridRow {
                Text("Actual:")
                    .fontWeight(.bold)
                ForEach(0..<2, id: \.self) { index in
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
        
        // Motivation insights
        VStack(spacing: 10) {
            Text("Motivation")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Before")
                        .fontWeight(.bold)
                        .frame(width: 80, alignment: .center)
                    Text("After")
                        .fontWeight(.bold)
                        .frame(width: 80, alignment: .center)
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    Text("\(Int(round(predicted[2])))")
                        .frame(width: 80, alignment: .center)
                    HStack(spacing: 4) {
                        IndicatorView(difference: actual[2] - predicted[2])
                            .frame(width: 10, height: 10)
                        Text("\(Int(round(actual[2])))")
                    }
                    .frame(width: 80, alignment: .center)
                }
            }
            .padding()
        }
    }
}

#Preview {
    InsightsView(predicted: [10, 20, 3], actual: [15, 15, 3])
}
