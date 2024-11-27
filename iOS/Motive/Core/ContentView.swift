//
//  ContentView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.currentRoute) {
            HomeView(router: router)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomeView(router: router)
                    case .measurement(let type):
                        MeasurementView(type: type)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
