//
//  PromptMeasurementView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/16/24.
//

import SwiftUI

enum PromptType {
    case pre
    case post
}

struct PromptMeasurementView: View {
    private let type: PromptType
    private let unlocked: Bool
    
    init(type: PromptType, unlocked: Bool) {
        self.type = type
        self.unlocked = unlocked
    }
    
    var body: some View {
        HStack {
            if unlocked {
                Image(type == .pre ? "gym" : "recovery")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
            } else {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
            }
            
            Text(type == .pre ? "Complete pre-workout report" : "Complete post-workout report")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}


#Preview {
    PromptMeasurementView(type: .pre, unlocked: true)
}
