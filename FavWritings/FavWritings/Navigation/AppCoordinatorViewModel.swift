//
//  AppCoordinatorViewModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import Combine
import FlowStacks
import SwiftUI

final class AppCoordinatorViewModel: ObservableObject {

    @Published var routes: Routes<Screen>

    init() {
        self.routes = [.root(.splash, embedInNavigationView: true)]
    }

    func goBack() {
        routes.goBack()
    }

    func goBackToRoot() {
        routes.goBackToRoot()
    }
    
    func setTabBarAsRootScreen() {
        routes = [.root(.tabContainer, embedInNavigationView: true)]
    }
}

