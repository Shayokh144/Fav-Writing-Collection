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
    @StateObject private var writingListViewModel: WritingsListViewModel
    @StateObject private var wordSearchViewModel: WordSearchViewModel
    @StateObject private var addNewItemViewModel: AddNewItemViewModel

    var body: some View {
        Router($coordinator.routes) { screen, _  in
            switch screen {
                case let .addImage(viewModel, onSelectImage):
                    AddImageScreen(
                        viewModel: viewModel, 
                        onTapUseImage: onSelectImage
                    )
                case .tabContainer:
                    TabContainerScreen(
                        writingListViewModel: writingListViewModel,
                        wordSearchViewModel: wordSearchViewModel,
                        addNewItemViewModel: addNewItemViewModel,
                        onTapWritingName: { uiModel in
                            coordinator.routes.push(.writingsDetails(uiModel))
                        }, 
                        onTapAddImage: {
                            let imageViewModel = AddImageViewModel()
                            coordinator.routes.push(
                                .addImage(
                                    imageViewModel,
                                    onSelectImage: { image in
                                        addNewItemViewModel.selectedImage = image
                                        coordinator.goBack()
                                    }
                                )
                            )
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
        _writingListViewModel = StateObject(wrappedValue: WritingsListViewModel())
        _wordSearchViewModel = StateObject(wrappedValue: WordSearchViewModel())
        _addNewItemViewModel = StateObject(wrappedValue: AddNewItemViewModel())
    }
}
