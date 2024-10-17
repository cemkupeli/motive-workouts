//
//  HomeView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/16/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Motive")
            .font(.custom("Kalam-Regular", size: 44).weight(.bold))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.indigo)
            .offset(y: -20)
        
        Spacer()
        
        CalendarView()
        
        Button {
            
        } label: {
            PromptMeasurementView(type: .pre)
        }
        
        Button {
            
        } label: {
            PromptMeasurementView(type: .post)
        }
        
        Spacer()
    }
}

#Preview {
    HomeView()
}
