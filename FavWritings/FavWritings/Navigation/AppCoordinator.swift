//
//  AppCoordinator.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import FlowStacks
import SwiftUI

struct AppCoordinator: View {
    
    @StateObject var coordinator: AppCoordinatorViewModel

    var body: some View {
        Router($coordinator.routes) { screen, _  in
            switch screen {
                case .tabContainer:
                    TabContainerScreen(
                        onTapWritingName: { uiModel in
                            coordinator.routes.push(.writingsDetails(uiModel))
                        }
                    )
                case let .writingsList(viewModel):
                    WritingsListScreen(
                        viewModel: viewModel,
                        onTapWritingName: { uiModel in
                            coordinator.routes.push(.writingsDetails(uiModel))
                        }
                    )
                case let .writingsDetails(uiModel):
                    WritingDetailsScreen(onTapBack: coordinator.goBack, uiModel: uiModel)
                case let .wordSearch(viewModel):
                    WordSearchScreen(viewModel: viewModel)
                case .splash:
                    SplashScreen(onFinishSplashAnimation: coordinator.setTabBarAsRootScreen)
            }
        }
    }
    
    init(coordinator: AppCoordinatorViewModel) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
}
