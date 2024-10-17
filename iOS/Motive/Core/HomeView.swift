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
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
            .background(.indigo)
            .offset(y: -30)
        
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
        Spacer()
    }
}

#Preview {
    HomeView()
}
