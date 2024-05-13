//
//  FavWritingsApp.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 7/5/24.
//

import SwiftUI

@main
struct FavWritingsApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator(coordinator: AppCoordinatorViewModel())
        }
    }
}
