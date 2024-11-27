//
//  ContentView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = Router()
    @StateObject var userDataManager = UserDataManager()
    @State private var showTerms = false
    
    var body: some View {
        NavigationStack(path: $router.currentRoute) {
            HomeView(router: router, userDataManager: userDataManager)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomeView(router: router, userDataManager: userDataManager)
                    case .measurement(let type):
                        MeasurementView(type: type)
                    }
                }
        }
        .onAppear {
            checkTermsAgreement()
        }
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
    }
    
    private func checkTermsAgreement() {
        if !UserDefaults.standard.hasAgreedToTerms {
            showTerms = true
        }
    }
}

#Preview {
    ContentView()
}
