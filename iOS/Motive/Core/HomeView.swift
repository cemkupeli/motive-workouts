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
                    PromptMeasurementView(type: .pre)
                }
                
                Button {
                    router.currentRoute.append(Route.measurement(type: .post))
                } label: {
                    PromptMeasurementView(type: .post)
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
                    print(userDataManager.user?.measurements)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    HomeView(router: Router(), userDataManager: UserDataManager())
}
