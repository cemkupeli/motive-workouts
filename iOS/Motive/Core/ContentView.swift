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
    
    var body: some View {
        if !router.agreedToTerms {
            TermsView(router: router)
        } else {
            NavigationStack(path: $router.currentRoute) {
                HomeView(router: router, userDataManager: userDataManager)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            HomeView(router: router, userDataManager: userDataManager)
                        case .measurement(let type):
                            MeasurementView(userDataManager: userDataManager, type: type)
                        case .summary:
                            SummaryView(userDataManager: userDataManager)
                        case .help:
                            HelpView()
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
