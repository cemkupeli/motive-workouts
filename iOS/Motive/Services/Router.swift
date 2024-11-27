//
//  Router.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import SwiftUI

enum Route: Hashable {
    case home
    case measurement(type: PromptType)
}

class Router: ObservableObject {
    @Published var currentRoute = NavigationPath()
}
